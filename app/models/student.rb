class Student < ApplicationRecord

  # QUERY CON INCLUDES QUE PUEDE SER UTIL:
  # Student.includes(:user, {academic_records: {section: {course_period: [{course: [:language, :level]}, :period]}}}).limit(5).each{|es|}
  # ========== RELATIONSHIPS ============ #

  belongs_to :user, inverse_of: :student#, foreign_key: :user_id
  # accepts_nested_attributes_for :user

	validates :user_id, presence: true
	validates :personal_identity_document, presence: true, uniqueness: true, unless: :new_record? #, case_sensitive: true

  has_many :careers, inverse_of: :student
  accepts_nested_attributes_for :careers

  has_many :academic_records, inverse_of: :student
  has_many :payment_details, through: :academic_records#, inverse_of: :student
  accepts_nested_attributes_for :academic_records
  
  has_many :sections, through: :academic_records

  # ========== VALIDATIONS ============ #

  before_save :upcase_location, unless: :new_record?
  # before_validation :upcase_location

  after_destroy :check_user_for_destroy

  scope :my_search, -> (keyword) { joins(:user).where("personal_identity_document LIKE '%#{keyword}%' OR users.email LIKE '%#{keyword}%' OR users.email LIKE '%#{keyword}%' OR users.last_name LIKE '%#{keyword}%'") }

  # ========== RAILS ADMIN ============ #

  def enrolled_course_period? (course_period_id)
    academic_records.joins(:section).where("sections.course_period_id = ?", course_period_id).any?
  end

  def before_import_save(record)
    # if (email = record[:user_email]) && (user = User.find_by_email(email))
      # self.personal_identity_document = self.personal_identity_document.delete! '^0-9'
      self.user_id = record[:user_id]
      self.personal_identity_document = record[:personal_identity_document]
      self.location = record[:location]
      self.source_country = 'Venezuela'
      self.active = record[:active]
    # end
  end

  rails_admin do

    import do
      mapping_key :user_id
      # for multiple values, use mapping_key [:first_name, :last_name]
      mapping_key_list [:personal_identity_document, :user_id, :user_email]

    end

    show do
      field :description do
        label 'Descripción'
        # css_class 'bg-dark text-white'
        formatted_value do
          bindings[:view].render(partial: "table_personal_info", locals: {object: self.bindings[:object]})
        end
      end

      field :records do
        label 'Inscripciones'
        formatted_value do
          bindings[:view].render(partial: "rails_admin/main/careers/index_student_careers", locals: {field: self})
        end
      end

      field :aceim_oldest_records do
        label 'Inscripciones ACEIM.UCV.VE (Anterior)'
        formatted_value do
          bindings[:view].render(partial: "aceim_old_academic_records_partial", locals: {student: self.bindings[:object]})
        end
      end

    end


    list do
      search_by :my_search
      field :personal_identity_document do
        label 'Cédula'
        column_width 100
      end
      field :name do
        label 'Usuario'
      end
      field :location do
        label 'Ubicación'
      end
    end

    edit do
      field :user do
        label 'Usuario'
      end
      field :personal_identity_document do
        label 'Cédula de Identidad'
        html_attributes do
          {:length => 8, :size => 8, :onInput => "$(this).val($(this).val().toUpperCase().replace(/[^0-9]/g,''))"}
        end
      end
      field :location do
        label 'Ubicación de Residencia'
      end
      field :source_country do
        label 'País de Origen'
      end

      field :academic_records do 
        label 'Registros Académicos'
      end
    end
  end

  # ========== FUNCTIONS ============ #

  def language_avaliables
    enrolled_languages = self.careers.map{|c| c.language.id}
    enrolled_languages.blank? ? Language.all : Language.where('id not IN (?)', enrolled_languages)
  end

  def ci
    self.personal_identity_document
  end

  def constance_name
    "#{user.full_name } (#{ci})"
  end

  def any_blank?
    personal_identity_document.blank? or location.blank? or source_country.blank?
  end
	
  def name
    aux = ""
    aux += "#{self.ci}" unless self.ci.blank?
    aux += " #{user.description}" if user
  end

  def upcase_location
    self.location = location.strip.upcase if self.location
  end

  def import_from_aceim
    begin
      total = 0
      url = "http://aceim.ucv.ve/aceim_dev/aceim/inscripcion/show/#{self.ci}.json"
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json'})
      response = http.request(request)
      body = JSON.parse(response.body)
      historiales = body['historiales']
      if historiales and historiales.any?
        historiales.reject{|h| h['tipo_estado_calificacion_id'].eql? 'SC'}.each do |ar|
          language_id = Language.idioma_to_language_id ar['idioma_id']
          level_id = Level.nivel_to_level_id ar['tipo_nivel_id']
          letter,year = ar['periodo_id'].split('-') 
          period_aux = Period.where(letter: letter, year: year).first
          course_aux = Course.where(language_id: language_id, level_id: level_id).first
          if course_aux and period_aux
            course_period_aux = CoursePeriod.where(period_id: period_aux.id, course_id: course_aux.id, kind: :mixtos).first
            if course_period_aux and !course_period_aux.academic_records.where(student_id: self.id).any?
              section = course_period_aux.sections.where(number: ar['seccion_numero']).first
              section = course_period_aux.sections.first if section.nil?
              if section
                agreement = Agreement.where(id: ar['tipo_convenio_id']).first
                ar_aux = AcademicRecord.new
                ar_aux.student_id = self.id
                ar_aux.section_id = section.id
                ar_aux.final_qualification = ar['nota_final']
                ar_aux.qualification_status_id = ar['tipo_estado_calificacion_id']
                ar_aux.agreement = agreement
                ar_aux.inscription_status = :confirmado if ar['tipo_estado_inscripcion_id'].eql? "INS"
                total += 1 if ar_aux.save
              end
            end
          end
        end
        self.update(imported: true)
        return ['success', "Total inscripciones importadas de aceim.ucv.ve: #{total}"]
      end
    rescue Exception => e
      return ['notice', "Error intentando importar desde aceim.ucv.ve: #{e}"]
    end






  end


  protected

  def check_user_for_destroy
    user_aux = User.find self.user_id
    user_aux.delete if user_aux.without_rol?
  end

end

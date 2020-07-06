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
      field :name do
        label 'Descripción'
        # css_class 'bg-dark text-white'
      end
      
      field :location do
        label 'Ubicación'
      end

      field :careers do
        label 'Idiomas Cursados'
      end
      # field :academic_records do
      #   label 'Registros Academicos'
      # end

      field :records do
        label 'Inscripciones'
        formatted_value do
          bindings[:view].render(partial: "table_personal_academic_records_partial", locals: {field: self})
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
    enrolled_languages.blank? ? Language.all : Language.where('id != ?', enrolled_languages)
  end

  def ci
    self.personal_identity_document
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

  protected

  def check_user_for_destroy
    user_aux = User.find self.user_id
    user_aux.delete if user_aux.without_rol?
  end

end

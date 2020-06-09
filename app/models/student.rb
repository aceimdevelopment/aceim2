class Student < ApplicationRecord

  # ========== RELATIONSHIPS ============ #

  belongs_to :user#, foreign_key: :user_id
  # accepts_nested_attributes_for :user

	validates :user_id, presence: true
	validates :personal_identity_document, presence: true, uniqueness: true, unless: :new_record? #, case_sensitive: true

  has_many :careers
  accepts_nested_attributes_for :careers

  has_many :academic_records
  accepts_nested_attributes_for :academic_records

  # ========== VALIDATIONS ============ #

  before_save :upcase_location, unless: :new_record?
  # before_validation :upcase_location


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

    list do
      field :user do
        label 'Usuario'
      end
      field :personal_identity_document do
        label 'PID'
      end
      field :location do
        label 'Ubicación'
      end
      field :source_country do
        label 'Origen'
      end
    end

    edit do
      field :user do
        label 'Usuario'
      end
      field :personal_identity_document do
        label 'Documento Personal de Identiicación'
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
    end
  end

  # ========== FUNCTIONS ============ #

  def any_blank?
    personal_identity_document.blank? or location.blank? or source_country.blank?
  end
	
  def name
    "#{user.description}" if user
  end

  def upcase_location
    self.location = location.strip.upcase #if self.location
  end

end

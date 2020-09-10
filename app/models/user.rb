class User < ApplicationRecord

  # ========== RELATIONSHIPS ============ #

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # has_one :user, through: :student
  
  # belongs_to :administrator, foreign_key: :user_id
  has_one :administrator, inverse_of: :user
  # accepts_nested_attributes_for :administrator
  has_one :student, inverse_of: :user, foreign_key: :user_id
  # accepts_nested_attributes_for :student
  has_one :instructor, inverse_of: :user
  # accepts_nested_attributes_for :instructor

  # ========== VALIDATIONS ============ #
  before_save :upcase_names, unless: :new_record?
  # before_validation :upcase_names
  # validates_uniqueness_of :email#, message: 'La sección ya existe para el período seleccionado', field_name: false
  validates :email, presence: true#, uniqueness: true
  validates :name, presence: true, unless: :new_record?
  validates :last_name, presence: true, unless: :new_record?
  # validates :password, presence: true, unless: :new_record?

  # validates :number_phone, presence: true, unless: :new_record?

  attr_accessor :allow_blank_password

  # ========== DEVISE ============ #
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable

  # ========== RAILS ADMIN ============ #

  rails_admin do

    # import do
    #   mapping_key :email
    #   # for multiple values, use mapping_key [:first_name, :last_name]
    #   mapping_key_list [:email, :name, :last_name, :number_phone]
    #   # field :email
    #   # field :name
    #   # field :last_name
    #   # field :number_phone
    #   # field :password
    # end

    list do
      checkboxes false
      sort_by :name
      field :last_name do
        label 'Apellidos'
      end
      field :name do
        label 'Nombre'
      end
      field :email do
        label 'Correo'
      end
      field :number_phone do
        label 'Número Telefónico'
      end
      field :administrator do
        label 'Administrador'
      end
      field :student do
        label 'Estudiante'
      end
      field :instructor do
        label 'Instructor'
      end
    end
    show do
      field :description do
        label 'Descripción'
        # css_class 'bg-dark text-white'
      end

      field :number_phone_style do
        label 'Número Telefónico'
        # css_class 'bg-dark text-white'
      end
      
      field :types_users do
        label 'Tipos de usuario'

      end
    end

    edit do
      field :name do
        label 'Nombres'
      end
      field :last_name do
        label 'Apellidos'
      end
      field :email do
        label 'Correo'
      end
      field :canvas_email do
        label 'Correo de Canvas'
      end

      field :login_id_canvas do
        label 'Login Id Canvas'
      end

      field :id_canvas do
        label 'Id Canvas'
      end

      field :number_phone do
        label 'Número Telefónico'
        html_attributes do
          {:length => 12, :size => 12, :onInput => "$(this).val($(this).val().toUpperCase().replace(/[^0-9]/g,''))"}
        end        
      end

      field :password do
        label 'Contraseña'
      end
      field :password_confirmation do
        label 'Confirmar Contraseña'
      end
    end
  end

  # ========== FUNCTIONS ============ #
  def name_for_email_canvas
    aux = canvas_email
    aux ||= email

    "#{name} #{last_name} <#{aux}>"
  end

  def number_phone_style
    number_phone ? self.split_phone.join(" - ") : ""
  end

  def types_users
    aux = []
    aux << 'Administrator' if administrator?
    aux << 'Estudiante' if student?
    aux << 'Instructor' if instructor?

    aux.to_sentence
  end

  def instructor?
    self.instructor ? true : false
  end

  def admin?
    administrator?    
  end

  def administrator?
    self.administrator ? true : false
  end

  def student?
    self.student ? true : false
  end

  def any_blank?
    return (name.blank? or last_name.blank? or number_phone.blank? or (student and student.any_blank?))
  end

  def full_name
    "#{name} #{last_name}"
  end

  def full_name_invert
    "#{last_name}, #{name}"
  end

  def description
    "#{full_name_invert} (#{email})"
  end

  def password_required?
    allow_blank_password ? false : super
  end

  def before_import_save(record)
    self.password = record[:password] #"aceim123"
    # @password = record[:password]
    p "Estamos Acá en before_import_save, record[password]: #{record[:password]}"
    # self.encrypted_password = password_digest(@password) if @password.present?
    # self.allow_blank_password = true
  end

  def upcase_names
    self.name = capitalize_by_word(self.name)
    self.last_name = capitalize_by_word(self.last_name) 
  end

  def capitalize_by_word(string)
    string.split.map{|w| w.capitalize}.join(" ")
  end

  def split_phone
    operator_code = self.number_phone[0..3] 
    complement = self.number_phone[3..10]
    return [operator_code, complement]
  end

  def any_rol?
    (self.how_many_roles? > 0)
  end

  def without_rol?
    (self.how_many_roles? == 0)
  end

  def how_many_roles?
    aux = 0
    aux += 1 if administrator?
    aux += 1 if student?
    aux += 1 if instructor?    
    return aux
  end
  # def before_import_attributes(record)
  #   p 'Estamos Acá en before_import_attributes'
  #   # self.encrypted_password = password_digest(@password) if @password.present?
  # end

  # def before_import_associations(record)
  #   # @password = record[:password]
  #   p 'Estamos Acá en before_import_associations'
  #   # self.encrypted_password = password_digest(@password) if @password.present?
  #   # record.delete(:password)
  # end

end

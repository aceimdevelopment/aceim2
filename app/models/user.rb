class User < ApplicationRecord

  # ========== RELATIONSHIPS ============ #

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # has_one :user, through: :student
  
  # belongs_to :administrator, foreign_key: :user_id
  has_one :administrator
  # accepts_nested_attributes_for :administrator
  has_one :student
  # accepts_nested_attributes_for :student
  belongs_to :instructor
  # accepts_nested_attributes_for :instructor

  # ========== VALIDATIONS ============ #
  before_save :upcase_names, unless: :new_record?
  # before_validation :upcase_names
  # validates_uniqueness_of :email#, message: 'La sección ya existe para el período seleccionado', field_name: false
  validates :email, presence: true#, uniqueness: true
  validates :name, presence: true, unless: :new_record?
  validates :last_name, presence: true, unless: :new_record?
  validates :number_phone, presence: true, unless: :new_record?

  attr_accessor :allow_blank_password

  # ========== DEVISE ============ #
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable

  # ========== RAILS ADMIN ============ #

  rails_admin do

    import do
      mapping_key :email
      # for multiple values, use mapping_key [:first_name, :last_name]
      mapping_key_list [:email, :name, :last_name, :number_phone]
      # field :email
      # field :name
      # field :last_name
      # field :number_phone
      # field :password
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
      field :number_phone do
        label 'Número Telefónico'
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

  def instructor?
    self.instructor ? true : false
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

  def description
    "#{last_name}, #{name} (#{email})"
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
    self.name = capitalize_by_word(name)
    self.last_name = capitalize_by_word(last_name) 
  end

  def capitalize_by_word(string)
    string.split.map{|w| w.capitalize}.join(" ")
  end

  def split_phone
    operator_code = @user.number_phone[0..3] 
    complement = @user.number_phone[3..10]
    return [operator_code, complement]
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

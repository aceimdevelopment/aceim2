class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # has_one :user, through: :student
  validates :email, presence: true#, uniqueness: true
  # validates_uniqueness_of :email#, message: 'La sección ya existe para el período seleccionado', field_name: false
  validates :name, presence: true
  validates :last_name, presence: true
  validates :number_phone, presence: true

  # belongs_to :administrator, foreign_key: :user_id
  has_one :administrator
  # accepts_nested_attributes_for :administrator
  has_one :student
  # accepts_nested_attributes_for :student
  has_one :instructor
  # accepts_nested_attributes_for :instructor


  attr_accessor :allow_blank_password

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable


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

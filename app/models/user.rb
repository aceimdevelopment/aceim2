class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :last_name, presence: true
  validates :number_phone, presence: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable
end

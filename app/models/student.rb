class Student < ApplicationRecord

  belongs_to :user, foreign_key: :user_id
  accepts_nested_attributes_for :user

	validates :user_id, presence: true
	validates :personal_identity_document, presence: true, uniqueness: true

  has_many :academic_records
  accepts_nested_attributes_for :academic_records

  def before_import_save(record)
    if (email = record[:user_email]) && (user = User.find_by_email(email))
      # self.personal_identity_document = self.personal_identity_document.delete! '^0-9'
      self.user_id = user.id
      self.source_country = 'Venezuela'
    end
  end
	
  def name
    "#{user.description}"
  end
end

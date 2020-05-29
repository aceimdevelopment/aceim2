class Student < ApplicationRecord

  belongs_to :user, foreign_key: :user_id
  accepts_nested_attributes_for :user

	validates :user_id, presence: true
	validates :personal_identity_document, presence: true, uniqueness: true#, case_sensitive: true

  has_many :careers
  accepts_nested_attributes_for :careers

  has_many :academic_records
  accepts_nested_attributes_for :academic_records

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
	
  def name
    "#{user.description}" if user
  end
end

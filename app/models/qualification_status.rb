class QualificationStatus < ApplicationRecord
	has_many :academic_records, inverse_of: :qualification_status

	rails_admin do
		show do
			field :id
			field :name
		end
		list do
			field :id
			field :name
		end
	end
end

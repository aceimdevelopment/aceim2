class QualificationStatus < ApplicationRecord
	has_many :academic_records, inverse_of: :qualification_status
end

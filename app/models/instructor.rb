class Instructor < ApplicationRecord
  # ========== RELATIONSHIPS ============ #
  
  belongs_to :user#, foreign_key: :user_id
  # accepts_nested_attributes_for :user
  
  has_many :sections
  accepts_nested_attributes_for :sections

  # ========== VALIDATIONS ============ #
  validates :user_id, presence: true

  # ========== SCOPE ============ #

  # ========== RAILS ADMIN ============ #
  def before_import_save(record)
    self.user_id = record[:user_id]
    # if (email = record[:user_email]) && (user_aux = User.find_by_email(email))
      # self.user_id = user_aux.id
    self.active = record[:active]
    # end
  end
  rails_admin do

    # import do
    #   mapping_key :user_id
    #   mapping_key_list [:active]
    # end

    edit do
      field :user do
        label 'usuario'
      end
      field :active do
        label 'Activo'
      end
    end

    list do
      configure :description do
        label 'Descricpción'
        formatted_value do
          bindings[:object].user.description
        end
        filterable false
        searchable false, class_name: :user #:name
      end

      fields :description
      # field :active do
      #   label 'Activo'
      # end
    end

  end 

  # ================ FUNCTIONS =================== #

  def name
    "#{user.description}" if user
  end



end

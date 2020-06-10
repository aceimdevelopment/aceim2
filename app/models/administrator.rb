class Administrator < ApplicationRecord
  belongs_to :user, inverse_of: :administrator#, foreign_key: :user_id
  # accepts_nested_attributes_for :user 
  validates :user_id, presence: true
  validates :role, presence: true
  enum role: [:desarrollador, :superadmin, :supervidor, :pasante, :administrativo]

  rails_admin do


    show do
      field :user do
        label 'Usuario'
        # css_class 'bg-dark text-white'
      end
      
      field :role do
        label 'Rol'
      end
    end
    
    edit do
      field :user do
        label 'usuario'
      end
      field :role do
        label 'rol'
      end
    end
    list do
      field :name do
        label 'Usuario'
      end
      field :role do
        label 'rol'
      end
    end
  end

  def before_import_save(record)
    # p "Fuera de la búsqueda de usuario: #{record}"
    if user_aux = User.find(record[:id])
      p "rol: #{record[:rol]}"
      self.user_id = user_aux.id
      self.role = Administrator::roles.key record[:rol].to_i
    end
  end

  def name
    "#{user.description}" if user
  end

end

class Administrator < ApplicationRecord
  # ========== ASSOCIATIONS ============ #

  belongs_to :user, inverse_of: :administrator#, foreign_key: :user_id
  # accepts_nested_attributes_for :user 

  # ========== VARIABLES ============ #

  enum role: [:desarrollador, :superadmin, :supervisor, :pasante, :administrativo, :administrativo_plus, :superadmin_plus]

  # ========== VALIDATIONS ============ #
  validates :user_id, presence: true
  validates :role, presence: true
  after_destroy :check_user_for_destroy

  def high_authotization?
    yo? or super_role?
  end


  def yo?
    self.user.email.eql? 'moros.daniel@gmail.com'
  end

  def super_role?
    desarrollador? or superadmin?
  end

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

  protected

  def check_user_for_destroy
    user_aux = User.find self.user_id
    user_aux.delete if user_aux.without_rol?
  end

end

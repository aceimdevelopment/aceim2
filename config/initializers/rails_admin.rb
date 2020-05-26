RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  config.model CoursePeriod do

    list do
      field :id
      field :course do
        label :curso
      end
      field :period do
        label :periodo
      end
      field :sections do
        label :secciones
      end
    end

    edit do
      field :course do
        label 'curso'
      end
      field :period do
        label 'periodo'
      end
    end

  end

  config.model Administrator do
    edit do
      field :user do
        label 'usuario'
      end
      field :role do
        label 'rol'
      end
    end
    list do
      field :user do
        label 'usuario'
      end
      field :role do
        label 'rol'
      end
    end
  end

  config.model Instructor do
    edit do
      field :user do
        label 'usuario'
      end
      field :active do
        label 'Activo'
      end
    end

    list do
      field :user do
        label 'usuario'
      end
      field :active do
        label 'Activo'
      end
    end

  end

  config.model Student do
    list do
      field :user do
        label 'Usuario'
      end
      field :personal_identity_document do
        label 'PID'
      end
      field :location do
        label 'Ubicación'
      end
      field :source_country do
        label 'Origen'
      end
    end

    edit do
      field :user do
        label 'Usuario'
      end
      field :personal_identity_document do
        label 'Documento Personal de Identiicación'
        html_attributes do
          {:length => 8, :size => 8, :onInput => "$(this).val($(this).val().toUpperCase().replace(/[^0-9]/g,''))"}
        end
      end
      field :location do
        label 'Ubicación de Residencia'
      end
      field :source_country do
        label 'País de Origen'
      end
    end
  end
  config.model User do
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


  config.model BankAccount do
    edit do
      field :id do
        label 'Identificador'
      end
      field :number do
        label 'Número'
      end
      field :holder do
        label 'Titular'
      end
      field :bank do
        label 'Banco'
      end
    end
  end

  config.model Bank do
    edit do
      field :id do
        label 'Identificador'
      end
      field :name do
        label 'Nombre'
      end
    end
  end

  config.model Period do
    label 'Periodo'
    list do
      field :name do
        label 'Id'
      end
      field :kind do
        label 'Tipo'
      end
    end

    edit do
      field :year do
        label 'Año'
        html_attributes do
          {:min => 2005, :max => 2040}
        end        
      end
      field :letter do
        label 'Letra'
        html_attributes do
          {:length => 1, :size => 1, :onInput => "$(this).val($(this).val().toUpperCase().replace(/[^A-Z|0-9]/g,'').charAt($(this).val().length-1))"}
        end
      # help 'Solo un caracter permitido'
      end
      field :kind do
        label 'Tipo'
      end
      # exclude_fields :created_at, :updated_at
    end
  end

  # ActiveRecord::Base.descendants.each do |imodel| 
  #   config.model "#{imodel.name}" do
  #     list do
  #       exclude_fields :created_at, :updated_at
  #     end
  #   end
  # end


#   config.model 'Language' do
#    object_label_method do
#      :custom_label_method
#    end
#  end

#  def custom_label_method
#    "#{self.name}"
#  end

  config.excluded_models = ["Item", "User"]

  ## == CancanCan ==
  config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end

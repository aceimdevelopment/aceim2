RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  config.model Period do
    label 'Periodo'
    list do
      field :desc
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
      exclude_fields :created_at, :updated_at
    end
  end

  # ActiveRecord::Base.descendants.each do |imodel| 
  #   config.model "#{imodel.name}" do
  #     list do
  #       exclude_fields :created_at, :updated_at
  #     end
  #   end
  # end


  config.model 'Language' do
    object_label_method do
      :custom_label_method
    end
  end

  def custom_label_method
    "#{self.name}"
  end

  config.excluded_models << "Item"

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

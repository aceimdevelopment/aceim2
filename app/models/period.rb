class Period < ApplicationRecord
    validates :year, presence: true
    validates :year, numericality: {only_integer: true, greater_than_or_equal_to: 2005, less_than_or_equal_to: 2040}
    validates :letter, presence: true

    validates :letter, length: {maximum: 1}

    validates_uniqueness_of :year, scope: :letter, message: 'Período ya creado', field_name: false 

    has_many :qualification_schemas, inverse_of: :period
    has_many :course_periods
    accepts_nested_attributes_for :course_periods
    has_many :courses, through: :course_periods
    accepts_nested_attributes_for :courses
    has_many :sections, through: :course_periods
    accepts_nested_attributes_for :sections
    has_many :academic_records, through: :sections
    accepts_nested_attributes_for :academic_records
    
    before_save :set_name
    # has_many :planes, through: :historialplanes, source: :plan

    # validates_uniqueness_of :horario_id, scope: [:dia, :entrada], message: 'Ya existe un horario con una hora de entrada igual para la sección.', field_name: false

    # ============== RAILS ADMIN ================= #
    rails_admin do
      label 'Periodo'
      list do
        sort_by :name
        field :name do
          label 'Id'
          sort_reverse true
        end

        field :total_preenrollment do
          label 'Preinscritos'
        end
        field :total_enrollment do
          label 'Confirmados'
        end

        field :enrollments do
          label 'Preinscripciones'
          formatted_value do
            url = "/periods/#{bindings[:object].id}/onoff_switch?function_to_switch=enrollment"
            bindings[:view].render(partial: "onoff_switch_partial", locals: {virtual_object: bindings[:object], titulo: 'On/Off Permitir PreInscripcion', url: url, to_checked: bindings[:object].enrollment, id_html: 'enrollment' , alert: false})
          end
        end
        field :canvas_autoregister do
          label 'Automatricular Canvas'
          formatted_value do
          alert = "Esta acción enviará correos masivos a los estudiantes confirmados en éste periodo ¿Está Seguro?"
            url = "/periods/#{bindings[:object].id}/onoff_switch?function_to_switch=canvas_autoregister"
            bindings[:view].render(partial: "onoff_switch_partial", locals: {virtual_object: bindings[:object], titulo: 'On/Off enlace Canvas automatricular', url: url, to_checked: bindings[:object].enabled_autoregister_canvas_link, id_html: 'canvasAutoregister', alert: alert})
          end
        end
        field :canvas_login do
          label 'Login Canvas'
          formatted_value do
            url = "/periods/#{bindings[:object].id}/onoff_switch?function_to_switch=canvas_login"
            bindings[:view].render(partial: "onoff_switch_partial", locals: {virtual_object: bindings[:object], titulo: 'On/Off enlace Canvas login', url: url, to_checked: bindings[:object].enabled_login_canvas_link, id_html: 'canvasLogin', alert: false})
          end
        end
      end

      show do
        field :name do
          label 'Id'
        end

        field :qualification_schemas do 
          label 'Esquemas de caificaciones'
        end

        field :programations do
          label 'Programaciones en éste período'
          formatted_value do
            bindings[:view].render(partial: "rails_admin/main/course_periods/index", locals: {virtual_object: bindings[:object]})
          end
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
        # field :qualification_schemas do 
        #   label 'Esquemas de caificaciones'
        # end
        
        # exclude_fields :created_at, :updated_at
      end
    end

    
    # ============== RAILS ADMIN END ============= #

    def allow_enrollments?
      self.enrollment
    end

    def total_preenrollment
      academic_records.preinscrito.count
    end

    def total_enrollment
      academic_records.confirmado.count
    end


    protected

    def set_name
      self.name = "#{year}-#{letter}"
    end
end














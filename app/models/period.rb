class Period < ApplicationRecord
    validates :year, presence: true
    validates :year, numericality: {only_integer: true, greater_than_or_equal_to: 2005, less_than_or_equal_to: 2040}
    validates :letter, presence: true

    validates :letter, length: {maximum: 1}

    validates_uniqueness_of :year, scope: :letter, message: 'Período ya creado', field_name: false 

    has_many :qualification_schemas, inverse_of: :period
    has_many :course_periods, inverse_of: :period
    accepts_nested_attributes_for :course_periods
    has_many :courses, through: :course_periods
    accepts_nested_attributes_for :courses
    has_many :sections, through: :course_periods
    accepts_nested_attributes_for :sections
    has_many :academic_records, through: :sections
    accepts_nested_attributes_for :academic_records

    scope :enrollment_active, -> {where(enrollment: true).last}
    before_save :set_name
    # has_many :planes, through: :historialplanes, source: :plan

    # validates_uniqueness_of :horario_id, scope: [:dia, :entrada], message: 'Ya existe un horario con una hora de entrada igual para la sección.', field_name: false

    default_scope { order([year: :desc, letter: :desc]) }

    # ============== RAILS ADMIN ================= #
    rails_admin do
      label 'Periodo'


      export do
        field :name do
          label 'id'
        end
        field :year do
          label 'Año'
        end
        field :letter do 
          label 'Letra'
        end
        field :total_preenrollment do
          label 'PREINS'
        end
        field :total_enrollment do
          label 'CONFIR'
        end
        field :total_assigned do
          label 'CANVAS'
        end

      end
      list do
        sort_by :name
        checkboxes false
        items_per_page 10
        field :name do
          label 'ID'
          sort_reverse true
        end

        field :total_preenrollment do
          label 'PREINS'
        end
        field :total_reported do
          label 'REPORT'
        end
        field :total_enrollment do
          label 'CONFIR'
        end

        field :total_assigned do
          label 'CANVAS'
        end

        field :total_sc do
          label 'SC'
        end

        field :total_approved do
          label 'APROB'
        end

        field :total_repproved do
          label 'REPROB'
        end

        field :total_pi do
          label 'PI'
        end


        field :enrollments do
          label 'PREINSCRIBIR'
          formatted_value do
            url = "/periods/#{bindings[:object].id}/onoff_switch?function_to_switch=enrollment"
            bindings[:view].render(partial: "onoff_switch_partial", locals: {virtual_object: bindings[:object], titulo: 'On/Off Permitir PreInscripcion', url: url, to_checked: bindings[:object].enrollment, id_html: 'enrollment' , alert: false})
          end
        end
        # field :canvas_autoregister do
        #   label 'Automatricular Canvas'
        #   formatted_value do
        #   alert = "Esta acción enviará correos masivos a los estudiantes confirmados en éste periodo ¿Está Seguro?"
        #     url = "/periods/#{bindings[:object].id}/onoff_switch?function_to_switch=canvas_autoregister"
        #     bindings[:view].render(partial: "onoff_switch_partial", locals: {virtual_object: bindings[:object], titulo: 'On/Off enlace Canvas automatricular', url: url, to_checked: bindings[:object].enabled_autoregister_canvas_link, id_html: 'canvasAutoregister', alert: alert})
        #   end
        # end

        field :qualification do
          label 'CALIFICAR'
          formatted_value do
            url = "/periods/#{bindings[:object].id}/onoff_switch?function_to_switch=enabled_qualification"
            bindings[:view].render(partial: "onoff_switch_partial", locals: {virtual_object: bindings[:object], titulo: 'On/Off Calificación', url: url, to_checked: bindings[:object].enabled_qualification, id_html: 'calification', alert: false})
          end
        end

        field :canvas_login do
          label 'LOGIN CANVAS'
          formatted_value do
            url = "/periods/#{bindings[:object].id}/onoff_switch?function_to_switch=canvas_login"
            bindings[:view].render(partial: "onoff_switch_partial", locals: {virtual_object: bindings[:object], titulo: 'On/Off enlace Canvas login', url: url, to_checked: bindings[:object].enabled_login_canvas_link, id_html: 'canvasLogin', alert: false})
          end
        end

        field :survey do
          label 'ENCUESTA'
          formatted_value do
            url = "/periods/#{bindings[:object].id}/onoff_switch?function_to_switch=show_survey"
            bindings[:view].render(partial: "onoff_switch_partial", locals: {virtual_object: bindings[:object], titulo: 'On/Off Calificación', url: url, to_checked: bindings[:object].show_survey, id_html: 'survey', alert: false})
          end
        end

      end

      show do

        field :description do
          label 'Descripción'
          formatted_value do
            bindings[:view].render(partial: "/periods/description_table", locals: {period: bindings[:object]})
          end
        end

        field :canvas_registers_status do
          label 'Registro de Usuarios en Canvas'

          formatted_value do

            if bindings[:object].academic_records.confirmado.not_canvas_registers.any?
              bindings[:view].render(partial: "/periods/canvas_register_status", locals: {period: bindings[:object]})
            else
              "Sin registros de Canvas por procesar."
            end
          end
        end

        field :clean_not_reported do
          label 'Preinscritos No Reportados'
          formatted_value do
            bindings[:view].render(partial: "/periods/clean_not_reported", locals: {period: bindings[:object]})
          end
        end

        field :qualification_report do 
          label 'Reporte de calificaciones'
          formatted_value do
            if bindings[:object].enabled_qualification?
              bindings[:view].render(partial: "rails_admin/main/qualification_schemas/index", locals: {qa_schemas: bindings[:object].qualification_schemas})
            else
              "Active las calificaciones para tener esta vista"
            end

          end
        end

        field :programations do
          label 'Programaciones en éste período'
          formatted_value do
            if bindings[:object].enabled_qualification?
              bindings[:view].render(partial: "rails_admin/main/course_periods/index", locals: {virtual_object: bindings[:object]})
            else
              "Active las calificaciones para tener esta vista"
            end
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
        
        field :academic_hours do
          label 'Horas Académicas'
        end
        # field :qualification_schemas do 
        #   label 'Esquemas de caificaciones'
        # end
        
        # exclude_fields :created_at, :updated_at
      end
    end

    
    # ============== RAILS ADMIN END ============= #

    def self.distance_between_active_enrollment_period any_period
      aux = Period.enrollment_active
      if aux
        return aux.distance_between(any_period)
      else
        return false
      end 
    end


    def distance_between another_period
      pes = Period.all
      index_self = pes.index self
      index_another = pes.index another_period
      if another_period.nil?
        return -1
      else
        return (index_self - index_another).abs
      end
    end
    def preview  
      pes = Period.all#.reverse
      aux_index = pes.index self
      aux_index += 1

      if (aux_index >= pes.size)
        return nil
      else
        return pes[aux_index]
      end
    end

    def self.ordered_by_year_and_letter
       Period.all.order([year: :desc, letter: :desc])
    end

    def allow_enrollments?
      self.enrollment
    end

    def total_approved
      academic_records.approved.count
    end

    def total_repproved
      academic_records.repproved.count
    end

    def total_pi
      academic_records.pi.count
    end

    def total_sc
      academic_records.not_qualifiqued.count
    end

    def total_reported
      academic_records.preinscrito.total_reported
    end

    def total_preenrollment
      academic_records.preinscrito.count
    end

    def total_enrollment
      academic_records.confirmado.count
    end

    def total_assigned
      academic_records.asignado.count
    end


    protected

    def set_name
      self.name = "#{year}-#{letter}"
    end
end

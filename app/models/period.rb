class Period < ApplicationRecord
    validates :year, presence: true
    validates :year, numericality: {only_integer: true, greater_than_or_equal_to: 2005, less_than_or_equal_to: 2040}
    validates :letter, presence: true

    validates :letter, length: {maximum: 1}

    validates_uniqueness_of :year, scope: :letter, message: 'Período ya creado', field_name: false 

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
        field :name do
          label 'Id'
        end

        field :total_preenrollment do
          label 'Preisncritos'
        end
        field :total_enrollment do
          label 'Confirmdos'
        end

      end

      show do
        field :name do
          label 'Id'
        end

        field :course_periods do
          label 'Programaciones'
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
        # exclude_fields :created_at, :updated_at
      end
    end

    
    # ============== RAILS ADMIN END ============= #


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














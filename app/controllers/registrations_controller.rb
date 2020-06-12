class RegistrationsController < Devise::RegistrationsController

  def create
    if GeneralSetup.permitir_registros_nuevos
      super
    else
      redirect_back fallback_location: root_path, flash: {error: 'Por el momento los nuevos registros no están permitidos. ¡Inténtalo más tarde!'}
    end
  end

  protected

  def after_sign_up_path_for(resource)
  	if params[:student] and Student.create(user_id: resource.id)
  		flash[:success] = "¡Registro exitoso!"
  		student_session_index_path
  	else
  		flash[:danger] = "Error al intentar registrar el estudiante. Por favor dirígete a los administradores del sistema"
  		redirect_back fallback_location: root
  	end
  end
end
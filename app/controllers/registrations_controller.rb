class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
  	if params[:student] and Student.create(user_id: resource.id)
  		flash[:success] = "¡Registro exitoso!"
  		student_session_index_path
  	else
  		flash[:error] = "Error al intentar registrar el estudiante. Por favor dirígete a los administradores del sistema"
  		redirect_back fallback_location: root
  	end
  end
end
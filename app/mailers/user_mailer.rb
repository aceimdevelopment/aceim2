class UserMailer < ApplicationMailer
  # default from: 'CONTACTO FUNDEIM <fundeimucv@gmail.com>'
  layout 'mailer'

  def reset_password_instructions(resource, authenticity_token, commit)
    @resource = resource
    @token = authenticity_token
    mail(to: @resource.email, subject: "Solicitud de Reinicio de Contraseña" )
  end

  def canvas_new_user_registration(user, status)
    @user = user
    @canvas_color = "<b style='color:red;'>CANVAS</b>"
    @aceim_color = "<b style='color:#6F9BED;'>ACEIM</b>"

    if (status.eql? 'no_sabe')
      @first_paragraph = "Hemos intentado crear su usuario en #{@canvas_color} pero el sistema nos indica que ya existe un usuario registrado con este correo. Debe haber recibido un correo con las indicaciones para recuperar su contraseña de #{@canvas_color}. Por favor, revise todas las carpetas de su buzón de entrada en su correo, siga las instrucciones para recuperar su contraseña y actualice su perfil en #{@canvas_color}"
    else

      @first_paragraph = "Hemos creado su usuario en #{@canvas_color}, su usuario es el mismo correo que tiene registrado en #{@aceim_color} y su contraseña temporal en #{@canvas_color} es <b>12341234</b>."
    end

    mail(to: user.email,
    subject: "CREACIÓN DE USUARIO EN CANVAS",
    content_type: "text/html")
  end

  def preenrollment_2020c(user)
    @user = user
    mail(to: user.email,
    subject: "ATENCIÓN PREINSCRITOS 2020-C",
    content_type: "text/html")
  end

  def asigneds_2020b(user)
    @user = user
    mail(to: user.email,
    subject: "INSCRIPCIONES PARA EL PROGRAMA FUNDEIM ONLINE 2020-C",
    content_type: "text/html")
    
  end

  def last_weeks_2020b(ids)
    @users = User.find(ids)
    mail(to: 'soporte@fundeim.com',
    bcc: @users.map{|u| u.email},
    subject: "Estudiantes 2020-B FUNDEIM ONLINE",
    content_type: "text/html")
    
  end


  def inscripcion_2020b(ids)
    ids += [1,2]
    @users = User.find(ids)
    # @user = User.find 2
    mail(to: 'soporte@fundeim.com',
    bcc: @users.map{|u| u.email},
    subject: "Registro en FUNDEIM ONLINE",
    content_type: "text/html")

  end

  def autoenrollment_canvas(enrollment)
    # @ar = AcademicRecord.find enrollment_id
    @ar = enrollment
    mail(to: @ar.user.email,
    # bcc: 'saavedraazuaje73@gmail.com',
    subject: "Automatricularse en Canvas",
    content_type: "text/html")
  end

  def general_email(ids)
    ids += [1,2]
    @users = User.find(ids)
    # @user = User.find 2
    
    mail(to: 'soporte@fundeim.com',
    bcc: @users.map{|u| u.email},
    subject: "Registro en FUNDEIM ONLINE",
    content_type: "text/html")

  end

  def confirmation_enrollment_email(ar_id)
    ar = AcademicRecord.find(ar_id)
    @user = ar.student.user
    @section = ar.section
    mail(to: @user.email,
    subject: "Confirmación de Inscripción #{ar.course_period.name}",
    content_type: "text/html")    
  end

  def encuesta(ids)
    ids += [1,2]
    users = User.where(id: ids)
    mail(to: 'soporte@mg.fundeim.com',
    bcc: users.map{|u| u.email},
    subject: "Encuesta FUNDEIM ONLINE",
    content_type: "text/html")

  end

  def prueba_plantilla
    user = User.find 2
    mail(to: user.email,
    subject: "Prueba de Plantilla FUNDEIM ONLINE",
    content_type: "text/html")    
  end
end

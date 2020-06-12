class UserMailer < ApplicationMailer
  layout 'mailer'

  def general_email(ids)
    ids += [1,2]
    @users = User.find(ids)
    # @user = User.find 2
    
    mail(to: 'soporte@fundeim.com',
    bcc: @users.map{|u| u.email},
    subject: "Registro en FUNDEIM ONLINE",
    content_type: "text/html")

  end

  def confirmation_enrollment_email(ar)
    # ar = AcademicRecord.find(id)
    @user = ar.student.user
    @section = ar.section
    mail(to: @user.email,
    subject: "Confirmación de Inscripción #{ar.course_period.name}",
    content_type: "text/html")    
  end
end

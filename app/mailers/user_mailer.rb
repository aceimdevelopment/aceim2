class UserMailer < ApplicationMailer
  default from: 'soporte@fundeim.com'
  layout 'mailer'

  def general_email(ids)
    @users = User.find(ids)
    # @user = User.find 2
    
    mail(to: 'soporte@fundeim.com',
    bcc: @users.map{|u| u.email},
    subject: "Correo de Prueba")

  end
end

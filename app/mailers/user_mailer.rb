class UserMailer < ApplicationMailer
  default from: 'soporte@fundeim.com'
  layout 'mailer'

  def general_email(ids)
    @users = User.find(ids)
    # @user = User.find 2
    
    mail(to: 'fundeim@mailinator.com',
    bco: @users.map{|u| u.email},
    subject: "Correo de Prueba")

  end
end

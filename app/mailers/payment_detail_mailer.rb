class PaymentDetailMailer < ApplicationMailer
  layout 'mailer'

  def send_payment_report(id)
    @payment_detail = PaymentDetail.find id
    @user = @payment_detail.user
    mail(to: @user.email,
    bcc: 'moros.daniel@gmail.com, saavedraazuaje73@gmail.com',
    subject: "Reporte de pago a FUNDEIM recibido",
    content_type: "text/html")
  end

  def report_new_pay(id)
    @payment_detail = PaymentDetail.find id
    @user = @payment_detail.user    
    @administrativos = Administrator.administrativo
    mail(to: 'saavedraazuaje73@gmail.com',
    cc: @administrativos.map{|a| a.user.email},
    subject: "Pago Reportado",
    content_type: "text/html")
  end

  def send_payment_confirmed(id)
    @payment_detail = PaymentDetail.find id
    @user = @payment_detail.user
    mail(to: @user.email,
    # bcc: 'saavedraazuaje73@gmail.com',
    subject: "Confirmación de pago a FUNDEIM",
    content_type: "text/html")
  end


end

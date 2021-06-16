class PaymentDetailMailerPreview < ActionMailer::Preview
  def send_payment_confirmed
    PaymentDetailMailer.send_payment_confirmed(PaymentDetail.last.id)
  end
end
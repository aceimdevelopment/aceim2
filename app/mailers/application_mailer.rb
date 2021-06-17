class ApplicationMailer < ActionMailer::Base
  INGRESO_REGULAR_BTN = "<a href='https://aceim.fundeim.com/users/sign_in' style='color: #fff;background-color: #0069d9;border-color: #0062cc;padding: 0.4rem 1rem;font-size: 1rem;line-height: 1;border-radius: 0.3rem;text-decoration: none;'>Ingreso Regular</a>"

  CANVAS_COLOR = "<b style='color:red;'>CANVAS</b>"
  ACEIM_COLOR = "<b style='color:#6F9BED;'>ACEIM</b>"
  ACEIM_LINK = "<a style='color:#6F9BED;font-weight: bold;text-decoration: none;' href='https://https://aceim.fundeim.com/users/sign_in'>ACEIM</a>"

  default from: 'CONTACTO FUNDEIM <fundeimucv@gmail.com>'
  layout 'mailer'
end

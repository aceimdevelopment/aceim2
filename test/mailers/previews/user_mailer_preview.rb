class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    UserMailer.welcome_email(User.last)
  end

  def pre_enrolled
    UserMailer.pre_enrolled(AcademicRecord.last)
  end

  def confirmation_enrollment_email
    UserMailer.confirmation_enrollment_email(AcademicRecord.last)
  end
end
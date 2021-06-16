class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    UserMailer.welcome_email(User.last)
  end

  def pre_enrolled
    UserMailer.pre_enrolled(AcademicRecord.last)
  end
end
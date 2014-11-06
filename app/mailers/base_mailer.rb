class BaseMailer < ActionMailer::Base
  layout "mailer"

  def before_call(user, locale)
    @old_locale  = I18n.locale
    I18n.locale  = locale

    @user = user
  end

  def generate_email(email, subject)
    mail = mail(to: email, subject: subject)
    mail.from = '"Ulu" <mail@ulu.com>'
    mail
  end

  def test_email(user, locale, subject)
    before_call(user, locale)
    generate_email(user.email, subject)
  end

  def after_call
    I18n.locale = @old_locale
  end

end

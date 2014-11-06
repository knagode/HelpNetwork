class UserMailer < BaseMailer

  def password_reset(user, locale)
    before_call(user, locale)

    @password_reset_url = edit_password_reset_url(@user.password_reset_token)
    mail = generate_email(user.email, t('user_mailer.password_reset.subject_ulu'))

    mail.deliver
    after_call
  end

  def email_verification(user, locale)
    before_call(user, locale)

    @email_vefrify_url = email_verification_url(@user.email_verification_token)
    mail = generate_email(user.email, t('user_mailer.email_verification.subject_ulu'))

    mail.deliver
    after_call
  end

  def email_fleet_relationship_accept(user, locale, new_user, fleet_relationship)
    before_call(user, locale)

    @fleet_relationship_accept = verification_fleet_relationship_url(fleet_relationship.request_token)
    mail = nil
    if new_user
      mail = generate_email(user.email, t('user_mailer.fleet_accept_new.subject_ulu'))
    else
      mail = generate_email(user.email, t('user_mailer.fleet_accept.subject_ulu'))
    end

    mail.deliver
    after_call

  end

end

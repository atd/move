class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.deliver_signup_notification(user)
  end

  def after_save(user)
    if user.class.password_recovery?
      UserMailer.deliver_activation(user) if user.recently_activated?
      UserMailer.deliver_lost_password(user) if user.recently_lost_password?
      UserMailer.deliver_reset_password(user) if user.recently_reset_password?
    end
  end
end

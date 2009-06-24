class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += I18n.t(:wellcome)
    @body[:user] = user
  end
  
  def lost_password(user)
    setup_email(user)
    @subject    += I18n.t(:request_change_password)
    @body[:url]  = "http://#{ Site.current.domain }/reset_password/#{ user.reset_password_code }"
  end

  def reset_password(user)
    setup_email(user)
    @subject    += I18n.t(:password_has_been_reset)
    @body[:url]  = "http://#{ Site.current.domain }/"
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = Site.current.email_with_name
      @subject     = "[#{ Site.current.name }] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end

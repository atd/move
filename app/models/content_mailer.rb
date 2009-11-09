class ContentMailer < ActionMailer::Base
  def notification(content)
    setup_email(content)
    @subject += content.title!
  end
  
 
  protected
    def setup_email(content)
      @recipients  = content.container.notification_emails
      @from        = Site.current.email_with_name
      @subject     = "[#{ Site.current.name }] "
      @sent_on     = Time.now
      @body[:content] = content
    end
end

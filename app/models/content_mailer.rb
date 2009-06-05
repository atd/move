class ContentMailer < ActionMailer::Base
  def notification(content)
    setup_email(content)
    @subject +=
      I18n.t("#{ content.class.to_s.underscore }.#{ content.created_at == content.updated_at ? 'created' : 'updated' }")
  end
  
 
  protected
    def setup_email(content)
      @recipients  = content.container.notification_email
      @from        = Site.current.email_with_name
      @subject     = "[#{ Site.current.name }] "
      @sent_on     = Time.now
      @body[:content] = content
    end
end

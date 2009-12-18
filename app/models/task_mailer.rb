class TaskMailer < ActionMailer::Base
  

  def notification(task, sent_at = Time.now)
    from       Site.current.email_with_name
    recipients task.notification_emails
    cc         task.container.notification_emails - task.notification_emails
    reply_to   task.notification_emails

    subject    task.parse(:email_subject)

    sent_on    sent_at
    
    body       :task => task,
               :body => task.parse(:email_body)
  end

end

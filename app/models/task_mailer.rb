class TaskMailer < ActionMailer::Base
  

  def next_turn(task, sent_at = Time.now)
    from       Site.current.email_with_name
    recipients task.turns.now.responsibles.map(&:notification_emails).flatten
    cc         task.container.notification_emails - task.turns.now.responsibles.map(&:notification_emails).flatten
    reply_to   task.turns.now.responsibles.map(&:notification_emails).flatten

    subject    task.parse(:email_subject)

    sent_on    sent_at
    
    body       :task => task,
               :body => task.parse(:email_body)
  end

end

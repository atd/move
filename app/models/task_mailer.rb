class TaskMailer < ActionMailer::Base
  

  def next_turn(task, sent_at = Time.now)
    subject    task.parse(:email_subject)
    recipients (Array(task.container.notification_email) | task.turns.now.responsibles.map(&:notification_email)).join(", ")
    from       Site.current.email_with_name
    sent_on    sent_at
    
    body       :task => task,
               :body => task.parse(:email_body)
  end

end

class AdmissionMailer < ActionMailer::Base

  def invitation(admission, sent_at = Time.now)
    subject    "[#{ Site.current.name }] #{ I18n.t('invitation.one') }"
    recipients admission.email
    from       Site.current.email_with_name
    sent_on    sent_at
    
    body       :invitation => admission
  end

  def processed_invitation(admission, sent_at = Time.now)
    subject    "[#{ Site.current.name }] #{ admission.state_message }"
    recipients ( Array(admission.introducer) | 
                 Array(admission.group.actors(:role => "Admin"))).map(&:email_with_name)
    from       Site.current.email_with_name
    sent_on    sent_at
    
    body       :invitation => admission
  end

end

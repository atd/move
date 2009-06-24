class AdmissionObserver < ActiveRecord::Observer
  def after_create(admission)
    case admission
    when Invitation
      AdmissionMailer.deliver_invitation(admission)
    end
  end

  def after_update(admission)
    case admission
    when Invitation
      AdmissionMailer.deliver_processed_invitation(admission)
    end if admission.recently_processed?
  end
end

require_dependency "#{ RAILS_ROOT }/vendor/plugins/station/app/models/invitation"

class Invitation
  authorization_delegate :group, :as => :performance

  authorizing do |agent, permission|
    if new_record?
      false
    end
  end

  authorizing do |agent, permission|
    if ( permission == :read || permission == :update )
      if candidate.blank?
        true
      else
        agent == candidate
      end
    end
  end
end

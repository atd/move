namespace :invitations do
  desc "Remember invitations every week"
  task :remember => :environment do
    Invitation.pending do |i|
      if i.created_at.wday == Time.now.wday
        AdmissionMailer.deliver_invitation(i)
      end
    end
  end
end


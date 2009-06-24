Factory.define :invitation do |a|
  a.association :candidate, :factory => :user
  a.association :group
  a.association :introducer, :factory => :user
  a.sequence(:email) { |n| "invited#{ n }@example.com" }
  a.role { |p| Group.roles.first }
  a.comment "Invitation"
end


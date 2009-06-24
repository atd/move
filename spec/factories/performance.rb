Factory.define :performance do |m|
  m.association :agent, :factory => :user
  m.association :stage, :factory => :group
end

Factory.define :admin, :parent => :performance do |m|
  m.role { |p| Group.role("Admin") }
end

Factory.define :participant, :parent => :performance do |m|
  m.role { |p| Group.role("Participate") }
end

Factory.define :observer, :parent => :performance do |m|
  m.role { |p| Group.role("Observe") }
end

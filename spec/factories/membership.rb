Factory.define :membership do |m|
  m.association :member
  m.association :group
end

Factory.define :participant do |m|
  m.association :member
  m.association :group
end

Factory.define :admin do |m|
  m.association :member
  m.association :group
end

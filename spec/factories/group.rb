Factory.define :group do |g|
  g.sequence(:name) { |n| "Group #{ n }" }
  g.association :user
end

Factory.define :container, :parent => :group do |g|
end

def populated_group
  g = Factory(:group)
  2.times do
    Factory(:admin, :stage => g)
  end
  5.times do
    Factory(:participant, :stage => g)
  end
  g
end

Factory.define :group do |g|
  g.sequence(:name) { |n| "Group #{ n }" }
  g.association :user
end

Factory.define :container, :parent => :group do |g|
end

Factory.define :public_group, :parent => :group do |g|
  g.others_read_content true
end

Factory.define :children_group, :parent => :group do |g|
  g.association :parent, :factory => :group
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

Factory.define :category do |c|
  c.sequence(:name) { |n| "Category #{ n }" }
  c.association :domain, :factory => :group
  c.description "Category description"
end


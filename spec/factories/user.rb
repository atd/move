Factory.define :user do |u|
  u.sequence(:login) { |n| "User #{ n }" }
  u.sequence(:email) { |n| "user#{ n }@example.com" }
  u.password "test"
  u.password_confirmation "test"
  u.created_at { Time.now }
  u.updated_at { Time.now }
  u.activated_at { Time.now }
end

Factory.define :author, :parent => :user do |a|
end
Factory.define :member, :parent => :user do; end

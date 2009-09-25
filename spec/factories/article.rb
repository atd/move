Factory.define :article do |a|
  a.sequence(:title) { |n| "Article #{ n }" }
  a.body "Article Content"
  a.public_read true
  a.association :container
  a.association :author
end

Factory.define :private_article, :parent => :article do |a|
  a.public_read false
end

Factory.define :user_article, :class => 'article' do |a|
  a.sequence(:title) { |n| "Article #{ n }" }
  a.body "Article Content"
  a.public_read true
  a.container { |c| c.association :author }
  a.association :author
end

Factory.define :private_user_article, :parent => :user_article do |a|
  a.public_read false
end


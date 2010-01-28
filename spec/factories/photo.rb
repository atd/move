Factory.define :photo do |a|
  a.sequence(:title) { |n| "Photo #{ n }" }
  a.description "Article Description"
  a.public_read true
  a.association :container
  a.association :author
  a.uploaded_data { ActionController::TestUploadedFile.new "#{ RAILS_ROOT }/public/images/models/96/site.png", "image/png" }
end

Factory.define :private_article, :parent => :article do |a|
  a.public_read false
end


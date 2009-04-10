class Article < ActiveRecord::Base
  include CommonContent

  acts_as_resource :per_page => 5

#  acts_as_versioned

  validates_presence_of :body
end

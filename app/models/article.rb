class Article < ActiveRecord::Base
  include CommonContent

  acts_as_resource :per_page => 5
  acts_as_versioned

  validates_presence_of :body

  class << self
    def params_from_atom(entry)
      { :title => entry.title.to_s,
        :body => entry.content.to_s }
    end
  end
end

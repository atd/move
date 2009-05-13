class Photo < ActiveRecord::Base
  include CommonContent

  has_attachment :content_type => :image,
                 :storage => :db_file,
                 :max_size => 1000.megabytes,
                 :thumbnails => { '600' => '600>',
                                  '96' => '96x96>',
                                  '64' => '64x64>' }

  acts_as_resource :mime_types => [ :jpeg, :gif, :png ],
                   :disposition => :inline,
                   :has_media => :attachment_fu,
                   :per_page => 15

  validates_as_attachment
end

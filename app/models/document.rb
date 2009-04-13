class Document < ActiveRecord::Base
  include CommonContent

  has_attachment :content_type => [ 'application/pdf', 
                                    'application/postscript', 
                                    'application/ps',
                                    'application/vnd.oasis.opendocument.text', 
                                    'application/vnd.oasis.opendocument.presentation', 
                                    'application/rtf', 
                                    'application/vnd.ms-powerpoint',
                                    'application/mspowerpoint',
                                    'application/vnd.ms-word',
                                    'application/msword', 
                                    'application/vnd.ms-excel',
                                    'application/msexcel' ],
                 :storage => :db_file,
                 :max_size => 1000.megabytes

  acts_as_resource :mime_types => [ :pdf, :ps, :odt, :odp, :rtf, :doc, :ppt, :xls ],
                   :disposition => :inline,
                   :has_media => :attachment_fu,
                   :per_page => 15,
                   :delegate_content_types => true
  acts_as_versioned

  validates_as_attachment
end

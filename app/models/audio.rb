class Audio < ActiveRecord::Base
  include CommonContent

  has_attachment :content_type => [ 'audio/x-wav',
                                    'audio/wav',
                                    'audio/x-vorbis+ogg',
                                    'application/ogg',
                                    'audio/mpeg' ], 
                 :storage => :file_system, :path_prefix => 'files/audios',
                 :max_size => 1000.megabytes

  after_attachment_saved :to_flv_if_modified

  acts_as_resource :mime_types => [ :wav, :mpeg, :ogg ],
                   :disposition => :attachment,
                   :has_media => :attachment_fu,
                   :per_page => 15
  
  validates_as_attachment

  def current_data_flv
    File.file?(_flv(full_filename)) ? File.read(_flv(full_filename)) : nil
  end

  def filename_flv
    _flv(filename)
  end

  private

  def to_flv_if_modified
    # Test changed attributes, because attachment_fu callback is broken and always runs on update
    to_flv if changed.include?('size') || changed.include?('filename')
  end

  def to_flv
    system "ffmpeg -y -i #{ full_filename } #{ _flv(full_filename) }"
  end

  def _flv(name)
    name =~ /\.\w*$/ ?
      name.gsub(/\.\w*$/, '.flv') :
      name + '.flv'
  end
end

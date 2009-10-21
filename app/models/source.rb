require_dependency "#{ RAILS_ROOT }/vendor/plugins/station/app/models/source"

class Source
  # Overwrite import method to allow public and private sources
  def import
    feed.entries.each do |entry|
      # Import feed entries until reach an already imported one
      break if imported_at && entry.updated < imported_at

      # FIXME!
      # Quick dirty hack for sources visibility support
      source_public_read = self.public_read
      (class << entry; self; end).class_eval do
        define_method(:public_read) { source_public_read }
      end unless entry.respond_to?(:public_read)

      # Find previous Importation with this guid
      if entry.id.present? && old_source_importation = source_importations.find_by_guid(entry.id)
        # Importation may have been deleted previously
        if old_source_importation.importation.present?
          old_source_importation.importation.from_atom!(entry)
        end
        old_source_importation.touch
      else
        link = entry.links.select{ |l| l['rel'] = 'alternate' }.first.try(:href)
        uri = link.present? ? Uri.find_or_create_by_uri(link) : nil

        # Create new Importation
        source_importations.create :importation => importation_class.new.from_atom!(entry),
                                   :guid => entry.id,
                                   :uri => uri
      end
    end

  end
end

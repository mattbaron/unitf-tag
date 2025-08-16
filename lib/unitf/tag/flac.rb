module UnitF
  module Tag
    class FLAC < UnitF::Tag::File
      def initialize(file_path)
        super(file_path)
        @file = TagLib::FLAC::File.new(file_path)
      end

      def info
        super.merge!({
          stats: stats,
          sample_rate: @file.audio_properties.sample_rate,
          bits_per_sample: @file.audio_properties.bits_per_sample
        })
      end

      def cover?
        @file.picture_list.each do |pic|
          return true if pic.type == TagLib::FLAC::Picture::FrontCover
        end
        false
      end

      def cover!(file_path)
        return if file_path.nil?

        UnitF::Log.info("Setting cover #{file_path}")
        pic = TagLib::FLAC::Picture.new
        pic.type = TagLib::FLAC::Picture::FrontCover
        pic.mime_type = 'image/jpeg'
        pic.description = 'Front Cover'
        pic.data = UnitF::Tag::CoverCache.cover_data(file_path)

        delete_cover! if cover?

        @file.add_picture(pic)
      end

      def delete_cover!
        @file.picture_list.each do |picture|
          @file.remove_picture(picture) if picture.type == TagLib::FLAC::Picture::FrontCover
        end
      end

      def album_artist=(artist)
        @file.xiph_comment.add_field('ALBUM ARTIST', artist, true)
      end

      def stats
        stats = @file.audio_properties
        sprintf('%.1fkHz/%d-bit %dkbps', stats.sample_rate / 1000.to_f, stats.bits_per_sample, stats.bitrate)
      end

      def raw_fields
        retun @raw_fields unless @raw_fields.nil?

        @raw_fields = {}
        @file.xiph_comment.field_list_map.each_pair do |key, value|
          @raw_fields[key] = value
        end

        @pictures = []
        @file.picture_list.each do |pic|
           @pictures << "Picture[#{pic.type}]:#{pic.description}"
        end
        @raw_fields['Pictures'] = @pictures.join(', ')

        @raw_fields
      end
    end
  end
end

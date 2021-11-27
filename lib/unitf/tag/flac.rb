module UnitF
  module Tag
    class FLAC < UnitF::Tag::File
      def initialize(file_path)
        super(file_path)
        @file = TagLib::FLAC::File.new(file_path)
      end

      def cover?
        @file.picture_list.each do |pic|
          return true if pic.type == TagLib::FLAC::Picture::FrontCover
        end
        false
      end

      def cover!(file_path)
        pic = TagLib::FLAC::Picture.new
        pic.type = TagLib::FLAC::Picture::FrontCover
        pic.mime_type = "image/jpeg"
        pic.data = ::File.open(file_path, 'rb') { |f| f.read }
        @file.add_picture(pic)
      end

      def delete_cover!
        @file.remove_pictures
      end

      def album_artist=(artist)
        @file.xiph_comment.add_field('ALBUM ARTIST', artist, true)
      end

      def dump
        puts "File: #{realpath}"
        tag = @file.xiph_comment
        tag.field_list_map.each_key do |key|
          puts "#{key}: #{tag.field_list_map[key]}"
        end
        puts
      end
    end
  end
end
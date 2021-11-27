require 'find'
require 'taglib'

module UnitF
  module Tag
    class File < Pathname
      def initialize(file_path)
        super(::File.absolute_path(file_path))
      end

      def tag
        @file.tag
      end

      def print
        puts "File  : #{realpath}"
        puts "Artist: #{tag.artist}"
        puts "Album : #{tag.album}"
        puts "Title : #{tag.title}"
        puts "Track : #{tag.track}"
        puts "Genre : #{tag.genre}"
        puts "Year  : #{tag.year}"
        puts "Cover : #{cover?}"
        puts
      end

      def cover_path
        "#{dirname}/cover.jpg"
      end

      def valid?
        extname.match(/(mp3|flac)$/i);
      end

      def mp3?
        extname.match(/\.mp3$/i)
      end

      def flac?
        extname.match(/\.flac$/i)
      end

      def cover?
        ::File.exists?(cover_path)
      end

      def auto_cover!
        cover!(cover_path)
      end

      def auto_tag!

      end

      def save
        @file.save
      end

      def close
        unless @file.nil?
          @file.close
          @file = nil
        end
      end

      def self.supported?(file_path)
        return File.file?(file_path) && file_path.match(/\.(flac|mp3)/i)
      end

      def open
        object = nil
        if flac?
          object = UnitF::Tag::FLAC.new(to_path)
        elsif mp3?
          object = UnitF::Tag::MP3.new(to_path)
        else
          object = nil
        end
        yield(object) if block_given?
        unless object.nil?
          object.close
        end
      end

      def self.find(root_path, recursive: true)
        files = []
        Find.find(root_path) do |file_path|
          next unless ::File.file?(file_path)
          next unless supported?(file_path)
          files << UnitF::Tag::File::new(file_path)
        end
        files
      end
    end
  end
end
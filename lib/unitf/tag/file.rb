require 'find'
require 'taglib'
require 'pathname'
require 'logger'

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

      def auto_tag_path
        "#{dirname}/.autotag"
      end

      def mp3?
        extname.match(/\.mp3$/i)
      end

      def flac?
        extname.match(/\.flac$/i)
      end

      def cover_available?
        ::File.exists?(cover_path)
      end

      def auto_cover!
        cover!(cover_path)
      end

      def auto_tag!
        title = ::File.basename(realpath.to_path)

        # This must come before gsubbing the title
        track = title.match(/^\s*\d+/).to_s.to_i

        title.gsub!(/\.\w+$/, '')
        title.gsub!(/^\d*\s*(\-|\.)*\s*/, '')

        path_parts = realpath.dirname.to_path.split('/')
        album = path_parts[-1]
        artist = path_parts[-2]

        tag.album = album
        tag.artist = artist
        tag.title = title
        tag.track = track
        self.album_artist = artist
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
    end
  end
end
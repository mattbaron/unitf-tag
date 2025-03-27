require 'find'
require 'taglib'
require 'pathname'
require 'logger'
require 'json'

module UnitF
  module Tag
    class File < Pathname
      def initialize(file_path)
        super(::File.absolute_path(file_path.to_s))
      end

      def tag
        raise Error, "File is not open #{self.class.name}" if @file&.tag.nil?

        @file&.tag
      end

      def save
        @file&.save
      end

      def close
        @file&.close
        @file = nil
      end

      def format_json
        JSON.pretty_generate(info)
      end

      def format_line
        buff = []
        info.each_key do |key|
          buff << "#{key}=#{info[key]}"
        end
        buff.join(',')
      end

      def info
        {
          file: realpath.to_path,
          artist: tag.artist,
          album: tag.album,
          title: tag.title,
          track: tag.track,
          genre: tag.genre,
          year: tag.year,
          cover: cover?
        }
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
        puts "Stats : #{stats}"
        puts
      end

      def cover_path
        ["#{dirname}/cover.jpg", "#{dirname}/../cover.jpg"].each do |path|
          return ::File.realpath(path) if ::File.exist?(path)
        end

        nil
      end

      def mp3?
        extname.match(/\.mp3$/i)
      end

      def flac?
        extname.match(/\.flac$/i)
      end

      def cover_available?
        !cover_path.nil?
      end

      def auto_cover!
        raise Error, "File is not open #{self.class.name}" if tag.nil?

        cover!(cover_path) if cover_available?
        true
      rescue StandardError => e
        UnitF::Log.error("Failed to auto-cover file #{e}")
        false
      end

      def auto_tags
        @auto_tags ||= UnitF::Tag::AutoTags.new(self)
      end

      def auto_tag!
        UnitF::Log.info("Auto tagging #{self}")
        tag.album = auto_tags[:album]
        tag.artist = auto_tags[:artist]
        tag.title = auto_tags[:title]
        tag.track = auto_tags[:track] if auto_tags.key?(:track)
        tag.year = auto_tags[:year] if auto_tags.key?(:year)
        self.album_artist = auto_tags[:artist]
      end

      def properties!(properties)
        properties.each_pair do |property, value|
          UnitF::Log.info("Setting #{property} to #{value}")
          tag.send("#{property}=", value)
        end
      end

      def update
        open(auto_save: true) do |file|
          yield(file) if block_given?
        end
      end

      def open(auto_save: false)
        file = if flac?
                   UnitF::Tag::FLAC.new(to_path)
                 elsif mp3?
                   UnitF::Tag::MP3.new(to_path)
                 end
        yield(file) if block_given?
        file.save if auto_save
        file.close
      end
    end
  end
end

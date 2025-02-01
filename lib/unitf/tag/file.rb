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
        cover_path != nil
      end

      def auto_cover!
        raise Error, "File is not open #{self.class.name}" if tag.nil?

        cover!(cover_path)
        true
      rescue StandardError => e
        UnitF::Log.error("Failed to auto-cover file #{e}")
        false
      end

      def manual_auto_tags
        UnitF::Log.info(auto_tag_path)
        tags = {}
        return {} unless ::File.exist?(auto_tag_path)
        ::File.read(auto_tag_path).each_line do |line|
          line.chomp!
          UnitF::Log.info(line)
          tag, value = line.split(/\s*=\s*/)
          tags[tag.to_sym] = value
        end
        tags
      rescue StandardError
        {}
      end

      # def auto_tags
      #   manual_tags = manual_auto_tags
      #   tags = {}

      #   tags[:title] = ::File.basename(realpath.to_path)
      #   track = tags[:title].match(/^\s*\d+/).to_s.to_i

      #   if tags[:title].scan(/(\.|_|-)(\d\d\d\d(\.|-)\d\d(\.|-)\d\d)/)
      #     tags[:title] = ::Regexp::last_match
      #   else
      #     tags[:title].gsub!(/\.\w+$/, '')
      #     tags[:title].gsub!(/^\d*\s*(-|\.)*\s*/, '')
      #   end

      #   path_parts = realpath.dirname.to_path.split('/')
      #   tags[:album] = path_parts[-1]
      #   tags[:artist] = path_parts[-2]

      #   tags.merge(manual_auto_tags)
      # end

      def auto_tag!
        UnitF::Log.info("Auto tagging #{self}")

        title = ::File.basename(realpath.to_path)
        path_parts = realpath.dirname.to_path.split('/')

        # This must come before gsubbing the title
        track = title.match(/^\s*\d+/).to_s.to_i

        if title.scan(/(\.|_|-)((\d\d\d\d)(\.|-)\d\d(\.|-)\d\d(\w*))\./).any?
          title = ::Regexp.last_match[2]
          album = "#{path_parts[-1]} #{::Regexp.last_match[3]}"
        else
          title.gsub!(/\.\w+$/, '')
          title.gsub!(/^\d*\s*(-|\.)*\s*/, '')
          album = path_parts[-1]
        end

        artist = path_parts[-2]

        tag.album = album
        tag.artist = artist
        tag.title = title
        tag.track = track
        self.album_artist = artist
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

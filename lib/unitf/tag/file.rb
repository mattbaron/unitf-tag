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
        @file.tag
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
        ::File.exist?(cover_path)
      end

      def auto_cover!
        cover!(cover_path)
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

      def save
        @file.save
      end

      def close
        @file&.close
        @file = nil
      end

      def open
        object = if flac?
                   UnitF::Tag::FLAC.new(to_path)
                 elsif mp3?
                   UnitF::Tag::MP3.new(to_path)
                 end
        yield(object) if block_given?
        object&.close
      end
    end
  end
end

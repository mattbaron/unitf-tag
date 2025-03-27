module UnitF
  module Tag
    class AutoTags < Hash
      def initialize(pathname)
        super

        pathname = Pathname.new(pathname) if pathname.is_a?(String)
        @pathname = pathname.realpath
        @dirname = pathname.realpath.dirname

        merge!(from_path)
        merge!(from_file)
      end

      def auto_tag_path
        return @auto_tag_path unless @auto_tag_path.nil?

        ["#{@dirname}/.autotag", "#{@dirname}/../.autotag"].each do |path|
          return @auto_tag_path = path if ::File.exist?(path)
        end

        nil
      end

      def from_path
        tags = {}

        tags[:title] = ::File.basename(@pathname)
        tags[:track] = tags[:title].match(/^\s*\d+/).to_s.to_i

        # Specific formatting for dated radio
        if tags[:title].scan(/(\.|_|-)((\d\d\d\d)(\.|-)\d\d(\.|-)\d\d(\w*))\./).any?
          tags[:title] = ::Regexp.last_match[2]
          tags[:year] = ::Regexp.last_match[3].to_i
        else
          tags[:title].gsub!(/\.\w+$/, '')
          tags[:title].gsub!(/^\d*\s*(-|\.)*\s*/, '')
        end

        path_parts = @dirname.to_s.split('/')
        tags[:artist] = path_parts[-2]
        tags[:album] = tags[:album_artist] = path_parts[-1]

        tags
      end

      def from_file
        tags = {}
        return tags unless ::File.exist?(auto_tag_path)

        ::File.read(auto_tag_path).each_line do |line|
          line.chomp!
          tag, value = line.split(/\s*=\s*/)
          tags[tag.strip.to_sym] = value.strip
        end

        tags
      rescue StandardError
        {}
      end
    end
  end
end
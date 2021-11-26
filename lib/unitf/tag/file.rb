require 'find'

module UnitF
  module Tag
    class File < Pathname
      def initialize(file_path)
        super(::File.absolute_path(file_path))
      end

      def cover_path
        "#{dirname}/cover.jpg"
      end

      def valid?
        extname.match(/(mp3|flac)$/i);
      end

      def self.find(root_path)
        files = []
        Find.find(root_path) do |item|
          next unless ::File.file?(item)
          file = UnitF::Tag::File.new(item)
          next unless file.valid?
          files << file
        end
        files
      end
    end
  end
end
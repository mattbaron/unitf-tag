module UnitF
  module Tagger
    class AudioFile < Pathname
      def initialize(file_path)
        super(File.absolute_path(file_path))
      end

      def cover_path
        "#{dirname}/cover.jpg"
      end

      def test
        puts dirname
      end
    end
  end
end
require 'unitf/logging'

module UnitF
  module Tag
    module Helpers
      def valid_file?(file_path)
        ::File.file?(file_path) && file_path.encode.match(/\.(flac|mp3)$/i)
      rescue ArgumentError => e
        UnitF::Log.error("Error processing #{file_path} - #{e.message}")
        false
      end
    end
  end
end

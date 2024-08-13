module UnitF
  module Tag
    class FileSet < Array
      include Helpers

      def initialize(targets)
        targets = [targets] if targets.is_a?(String)
        targets.each do |target|
          process_target(target)
        end
      end

      def process_target(target)
        UnitF::Log.debug("Processing target #{target}...")
        if ::File.directory?(target)
          find_files(target)
        elsif valid_file?(target)
          append(UnitF::Tag::File.new(target))
        end
      end

      def find_files(root_path)
        Find.find(root_path) do |file_path|
          UnitF::Log.debug("Considering #{file_path}")
          next unless valid_file?(file_path)

          UnitF::Log.debug("Including #{file_path}")
          append(UnitF::Tag::File.new(file_path))
        end
      end
    end
  end
end

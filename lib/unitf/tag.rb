# frozen_string_literal: true

require_relative "tag/version"
require_relative "tag/file"
require_relative "tag/flac"
require_relative "tag/mp3"

module UnitF
  module Tag
    class Error < StandardError; end

    def self.valid_file?(file_path)
      return ::File.file?(file_path) && file_path.match(/\.(flac|mp3)/i)
    end

    def self.process_target_dir(target_dir)
      puts "Processing target_dir #{target_dir}"
      files = []
      Dir.glob("#{target_dir}/*").each do |file|
        puts file
      end
    end

    def self.process_target(target)
      files = []
      if ::File.directory?(target)
        files = find_files(target)
      elsif valid_file?(target)
        files << UnitF::Tag::File.new(target)
      end
      files
    end

    def self.find_files(root_path)
      files = []
      Find.find(root_path) do |file_path|
        next unless ::File.file?(file_path)
        next unless valid_file?(file_path)
        files << UnitF::Tag::File::new(file_path)
      end
      files
    end
  end
end

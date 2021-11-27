# frozen_string_literal: true

require_relative "tag/version"
require_relative "tag/file"
require_relative "tag/flac"
require_relative "tag/mp3"

module UnitF
  module Tag
    class Error < StandardError; end

    def self.process_target_dir(target_dir)
      files = []

    end

    def self.process_target(target)
      files = []
      if File.directory?(target)
        files = process_target_dir
      elsif UnitF::Tag::File.supported?(target)
        files << UnitF::Tag::File.new(target)
      end
      files
    end
  end
end

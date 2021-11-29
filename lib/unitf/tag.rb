# frozen_string_literal: true

require_relative 'tag/version'
require_relative 'tag/file'
require_relative 'tag/fileset'
require_relative 'tag/flac'
require_relative 'tag/mp3'

require 'unitf/logging'

module UnitF
  module Tag
    class Error < StandardError; end
    class MissingCover < Error; end

    def self.logger
      unless @logger
        @logger = UnitF::Logging::Logger.new
        @logger.add_writer(UnitF::Logging::ConsoleWriter.new)
      end
      @logger
    end

    def self.valid_file?(file_path)
      ::File.file?(file_path) && file_path.encode.match(/\.(flac|mp3)$/i)
    rescue ArgumentError => e
      logger.error("Error processing #{file_path} - #{e.message}")
      false
    end

    def self.process_target(target)
      if ::File.directory?(target)
        find_files(target)
      elsif valid_file?(target)
        [UnitF::Tag::File.new(target)]
      else
        []
      end
    end

    def self.find_files(root_path)
      files = []
      Find.find(root_path) do |file_path|
        logger.debug("Considering #{file_path}")
        next unless valid_file?(file_path)
        files << UnitF::Tag::File.new(file_path)
      end
      files
    end

    def self.list(files, format: :json)
      buff = []
      files.each do |file|
        file.open do |o|
          case format
          when :json
            buff << o.info
          when :line
            puts o.format_line
          else
            o.print
          end
        end
      end
      puts JSON.pretty_generate(buff) if format == :json
    end
  end
end

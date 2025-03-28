# frozen_string_literal: true

require_relative 'tag/helpers'
require_relative 'tag/version'
require_relative 'tag/file'
require_relative 'tag/fileset'
require_relative 'tag/flac'
require_relative 'tag/mp3'
require_relative 'tag/auto_tags'

require 'unitf/logging'

module UnitF
  module Tag
    class << self
      def update(file_path)
        UnitF::Tag::File.new(file_path).update do |file|
          yield file
        end
      end

      def list(files, format: :json)
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

    class Error < StandardError; end
    class MissingCover < Error; end
  end
end

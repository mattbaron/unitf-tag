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

      def open(file_path)
        UnitF::Tag::File.new(file_path).open do |file|
          yield file
        end
      end

      def dump(files)
        files.each do |file|
          file.open do |f|
            f.dump
          end
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

      def auto_track(dir)
        raise Error,  "Invalid directory #{dir}" unless ::Dir.exist?(dir)

        UnitF::Log.info("Auto track #{dir}")
        track = 1

        Dir.glob("#{dir}/*.mp3").sort.each do |file_path|
          if ::File.basename(file_path).match?(/^\d+(\s|\.|-)/)
            UnitF::Log.warn("Skipping #{file_path}")
            next
          end

          UnitF::Tag.open(file_path) do |file|
            if file.tag.track != track
              UnitF::Log.info("Setting track to #{track} #{file_path}")
              file.tag.track = track
              file.save
            end
          end

          track += 1
        end
      end
    end

    class Error < StandardError; end

    class MissingCover < Error; end
  end
end

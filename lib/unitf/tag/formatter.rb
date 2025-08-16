module UnitF
  module Tag
    module Formatter
      class << self
        def default(file)
          buff = []
          buff << "File  : #{file.realpath}"
          buff << "Artist: #{file.fields[:artist]}"
          buff << "Album : #{file.fields[:album]}"
          buff << "Title : #{file.fields[:title]}"
          buff << "Track : #{file.fields[:track]}"
          buff << "Genre : #{file.fields[:genre]}"
          buff << "Year  : #{file.fields[:year]}"
          buff << "Cover : #{file.fields[:cover]}"
          buff << "Stats : #{file.stats}"
          buff.join("\n")
        end

        def raw(file)
          buff = []
          buff << "File: #{file.realpath}"
          file.raw_fields.each_pair do |key, value|
            buff << "#{key}: #{value}"
          end
          buff.join("\n")
        end

        def kvp(file)
          buff = []
          file.extended_fields.each_key do |key|
            buff << "#{key}=#{file.extended_fields[key]}"
          end
          buff.join(',')
        end
      end
    end
  end
end

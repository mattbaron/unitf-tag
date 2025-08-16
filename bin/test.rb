require 'optparse'

require 'unitf/tag'

base = '/Users/mbaron/tmp/music'

file = UnitF::Tag::File.new("#{base}/fIREHOSE/Sometimes/01 - Sometimes.flac")
cover = UnitF::Tag::CoverCache.cover_for(file)

puts "Cover nil? #{cover.nil?}"
puts UnitF::Tag::CoverCache.info

file = UnitF::Tag::File.new("#{base}/fIREHOSE/Sometimes/02 - For The Singer Of R.E.M..flac")
cover = UnitF::Tag::CoverCache.cover_for(file)

puts "Cover nil? #{cover.nil?}"
puts UnitF::Tag::CoverCache.info
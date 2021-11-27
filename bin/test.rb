require 'optparse'

require 'unitf/tag'

file_str = '/Users/mbaron/tag/music/fIREHOSE3/Sometimes'
file = UnitF::Tag::File.new(file_str)

puts file.to_s

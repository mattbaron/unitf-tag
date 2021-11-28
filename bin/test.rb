require 'optparse'

require 'unitf/tag'

file_str = '/Users/mbaron/tag/music/fIREHOSE3/Sometimes/01 - Sometimes.flac'

file = UnitF::Tag::FLAC.new(file_str)

file.open do |o|
  pp o.info
end
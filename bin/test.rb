require 'optparse'

require 'unitf/tag'

UnitF::Log.to_console

UnitF::Tag::File.update('/Users/mbaron/tmp/foo.mp3') do |tag|
  tag.artist = 'bar123'
  tag.year = 1972
end

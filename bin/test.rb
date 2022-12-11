require 'optparse'

require 'unitf/tag'

UnitF::Log.to_console

UnitF::Tag.update('/Users/mbaron/tmp/foo.mp3') do |file|
  file.tag.artist = 'bar123'
  file.tag.year = 1972
  file.auto_cover!
end

require 'optparse'

require 'unitf/tag'

UnitF::Log.to_console

UnitF::Tag.update('test-data/song.mp3') do |file|
  puts "FILE: #{file}"
  file.tag.artist = "Update #{Time.now.to_s}"
end

require 'optparse'

require 'unitf/tag'

UnitF::Log.to_console

UnitF::Tag.update('test-data/foo.mp3') do |file|
  file.tag.artist = 'bar123'
  file.tag.year = 1972
  file.tag.album = 'This is the album'
  file.tag.title = 'This is the title'
  file.tag.track = 99
  file.auto_cover!
end

file = UnitF::Tag::File.new('test-data/bar.mp3')
# file.tag

file.update do |f|
  f.tag.title = 'Hello world2!'
  f.tag.track = 100
end

file.open do |f|
  f.tag.title = 'Hello world9!'
end

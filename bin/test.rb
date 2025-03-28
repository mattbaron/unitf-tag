require 'optparse'

require 'unitf/tag'

UnitF::Log.to_console

UnitF::Tag.update('/Users/mbaron/git/unitf-tag/test-data/foo.mp3') do |file|
  file.tag.artist = "Update #{Time.now.to_s}"
end

file = "/Users/mbaron/music2/WFMU/BJ/2025/foo/bar/../../bj250321.mp3"

tags = UnitF::Tag::AutoTags.new(file)

puts tags
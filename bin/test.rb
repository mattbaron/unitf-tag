require 'optparse'

require 'unitf/tag'

UnitF::Log.to_console

file = UnitF::Tag::File.new('/Users/mbaron/tmp/WFMU/BJ/bj211119.mp3')
file.open do |o|
  puts o.auto_tags
end
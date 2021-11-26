require 'find'

require 'unitf/tag'

file_str = '../../tag/music/If\'n/01-Sometimes.mp3'
file_str = '/Users/mbaron/tmp/foo-bar.txt'
root = '/Users/mbaron/tag/music'

# begin
#   file = File.new(file_str)
# rescue Errno::ENOENT => e
#   puts "No such file #{file_str}"
# end

#puts Dir.glob('/Users/mbaron/google-cloud-sdk/**/*')

# Find.find('../../tag/music') do |path|
#   next unless File.file?(path)
#   file = UnitF::Tag::AudioFile.new(path)
#   puts file.cover_path
# end

UnitF::Tag::File.find(root).each do |file|
  puts file.cover_path
end

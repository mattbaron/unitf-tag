require 'find'

require 'unitf/tagger'

file_str = '../../tag/music/If\'n/01-Sometimes.mp3'
file_str = '/Users/mbaron/tmp/foo-bar.txt'

# begin
#   file = File.new(file_str)
# rescue Errno::ENOENT => e
#   puts "No such file #{file_str}"
# end

#puts Dir.glob('/Users/mbaron/google-cloud-sdk/**/*')

Find.find('../../tag/music') do |path|
  next unless File.file?(path)
  file = UnitF::Tagger::AudioFile.new(path)
  puts file.cover_path
end

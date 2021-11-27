require 'find'

require 'unitf/tag'

file_str = '../../tag/music/If\'n/01-Sometimes.mp3'
file_str = '/Users/mbaron/tmp/foo-bar.txt'
root = '/Users/mbaron/tag/music'

UnitF::Tag::File.find(root).each do |file|
  file.open do |obj|
    obj.print
    #obj.delete_cover!
    #obj.auto_cover!
    #obj.save
  end
end

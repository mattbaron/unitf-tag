require 'optparse'

require 'unitf/tag'

actions = []
opt = {
  :recursive => false
}

targets = OptionParser.new do |opts|
  opts.on('-r', '--recursive', 'Auto Cover') do |item|
    opt[:recursive] = true
  end

  opts.on('--auto_cover', 'Auto Cover') do |item|
    actions << :auto_cover
  end

  opts.on('--auto_tag', 'Auto Tag') do |item|
    actions << :auto_tag
  end

  opts.on('--artist ARTIST', 'Artist') do |arg|
    actions << :artist
    opt[:artist] = arg
  end

  opts.on('--album ALBUM', 'Album') do |arg|
    actions << :album
    opt[:album] = arg
  end

  opts.on('--title TITLE', 'Song Title') do |arg|
    actions << :title
    opt[:title] = arg
  end

  opts.on('--genre GENRE', 'Genre') do |arg|
    actions << :genre
    opt[:genre] = arg
  end
end.parse!

pp actions
pp opt
pp targets

targets.each do |target|
  puts "TARGET: #{target}"
  UnitF::Tag::process_target(target)
end

# if targets.size.zero? && actions.size.zero?
#   files = UnitF::Tag::File.find('.')
# end

# pp files

# UnitF::Tag::File.find(root).each do |file|
#   file.open do |obj|
#     obj.print
#     #obj.delete_cover!
#     #obj.auto_cover!
#     #obj.save
#   end
# end

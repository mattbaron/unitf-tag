module UnitF
  module Tag
    class MP3 < UnitF::Tag::File
      def initialize(file_path)
        super(file_path)
        @file = TagLib::MPEG::File.new(file_path)
      end

      def stats
        sprintf("%.1fkHz/%dkbps", @file.audio_properties.sample_rate / 1000.to_f, @file.audio_properties.bitrate)
      end

      def info
        super.merge!({
          stats: stats,
          sample_rate: @file.audio_properties.sample_rate,
          bitrate: @file.audio_properties.bitrate
        })
      end

      def cover?
        @file.id3v2_tag.frame_list('APIC').size > 0
      end

      def cover!(file_path)
        apic = TagLib::ID3v2::AttachedPictureFrame.new
        apic.mime_type = "image/jpeg"
        apic.description = "Cover"
        apic.type = TagLib::ID3v2::AttachedPictureFrame::FrontCover
        apic.picture = ::File.open(file_path, 'rb') { |f| f.read }
        @file.id3v2_tag.add_frame(apic)
      end

      def delete_cover!
        @file.id3v2_tag.remove_frames('APIC')
      end

      def album_artist=(artist)
        @file.id3v2_tag.remove_frames('TPE2')
        frame = TagLib::ID3v2::TextIdentificationFrame.new("TPE2", TagLib::String::UTF8)
        frame.text = artist
        @file.id3v2_tag.add_frame(frame)
      end

      def dump
        puts "File: #{realpath}"
        tag = @file.id3v2_tag
        tag.frame_list.each do |frame|
          next unless frame.is_a?(TagLib::ID3v2::TextIdentificationFrame)
          puts "#{frame.frame_id}: #{tag.frame_list(frame.frame_id).first}"
        end
        puts
      end
    end
  end
end

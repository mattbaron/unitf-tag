module UnitF
  module Tag
    class MP3 < UnitF::Tag::File
      def initialize(file_path)
        super(file_path)
        @file = TagLib::MPEG::File.new(file_path)
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
    end
  end
end

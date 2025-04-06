RSpec.describe UnitF::Tag::File do
  context "for a regular file" do
    before(:all) do
      @file = UnitF::Tag::File.new('test-data/Test Artist/Test Album/04 - Test Song.mp3')
    end

    it "can find the artist auto-tag" do
      expect(@file.auto_tags[:artist]).to eq('Test Artist')
    end

    it "can find the album auto-tag" do
      expect(@file.auto_tags[:album]).to eq('Test Album')
    end

    it "can find the track auto-tag" do
      expect(@file.auto_tags[:track]).to eq(4)
    end

    it "can find the title auto-tag" do
      expect(@file.auto_tags[:title]).to eq('Test Song')
    end
  end

  context "for a radio file" do
    before(:all) do
      @file = UnitF::Tag::File.new('test-data/WFMU/BJ/2025/bj250915.mp3')
    end

    it "can find the artist auto-tag" do
      expect(@file.auto_tags[:artist]).to eq('BJ')
    end

    it "can find the album auto-tag" do
      expect(@file.auto_tags[:album]).to eq('2025')
    end

    it "can find the title auto-tag" do
      expect(@file.auto_tags[:title]).to eq('bj250915')
    end
  end

  context "for a file with tag hints" do
    before(:all) do
      @file = UnitF::Tag::File.new('test-data/Foo/Bar/2025/qq250916.mp3')
    end

    it "can find the artist auto-tag" do
      expect(@file.auto_tags[:artist]).to eq('Custom Artist')
    end

    it "can find the album auto-tag" do
      expect(@file.auto_tags[:album]).to eq('Custom Album')
    end
  end
end

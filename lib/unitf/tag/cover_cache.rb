module UnitF
  module Tag
    module CoverCache
      class << self
        def covers
          @covers ||= {}
        end

        def max_size
          @max_size ||= 25
        end

        def cover_data(file_path)
          return nil if file_path.nil?

          invalidate! if size > max_size

          if covers[file_path].nil?
            UnitF::Log.debug("Reading cover data from #{file_path}")
            covers[file_path] = ::File.binread(file_path)
          else
             UnitF::Log.debug("Using cached cover data for #{file_path}")
          end

          covers[file_path]
        end

        def size
          covers.size
        end

        def invalidate!
          @covers = nil
        end
      end
    end
  end
end

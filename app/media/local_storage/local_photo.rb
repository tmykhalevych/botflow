require_relative '../cacher.rb'

module App
    class LocalPhoto < ::Telegram::Photo

        def initialize(name, cache_storage)
            @path = CONFIG[:STORAGE_PATH] + name
            @cache = Cacher.new(cache_storage, path)
        end

        def new?
            !cache.load
        end

        def save(resp)
            cache.save get_id_from(resp)
        end

        private

        attr_reader :path, :cache

        def source
            if new? then
                Faraday::UploadIO.new(path, 'image/jpeg')
            else
                cache.load
            end
        end
    end
end

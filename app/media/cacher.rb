require 'digest/md5'

module App
    class Cacher
        def initialize(cache_storage, path)
            @cache_storage, @path = cache_storage, path
        end

        def save(data)
            cache_storage.set md5, data
        end

        def load
            cache_storage.get md5
        end

        protected

        attr_reader :cache_storage, :path

        def md5
            @cache_hash ||= Digest::MD5.file(path).hexdigest
        end
    end
end

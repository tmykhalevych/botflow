require_relative '../media_abstract_factory.rb'
require_relative 'local_photo.rb'

module App
    class LocalStorageFactory < MediaAbstractFactory
        def newPhoto(opts)
            LocalPhoto.new(opts, cache)
        end
    end
end

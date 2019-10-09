module App
    class MediaAbstractFactory
        def initialize(cache)
            @cache = cache
        end

        def newPhoto(opts)
            not_implemented
        end

        def newAudio(opts)
            not_implemented
        end

        def newDocument(opts)
            not_implemented
        end

        def newVideo(opts)
            not_implemented
        end

        def newAnimation(opts)
            not_implemented
        end

        def newVoice(opts)
            not_implemented
        end

        def newVideoNote(opts)
            not_implemented
        end

        def newLocation(opts)
            not_implemented
        end

        def newFile(opts)
            not_implemented
        end

        protected

        attr_accessor :cache

        private

        def not_implemented
            raise NoMethodError.new('The method you are trying to call does not implemmented in \'MediaAbstractFactory\'. Please implement it in subclass!')
        end
    end
end

module Service
  module Concerns
    module Extractable
      extend ::ActiveSupport::Concern

      EXTRACTORS = {
        links: Extractors::Links,
        images: Extractors::Images
      }

      class_methods do
        def extractable
          Proc.new(&method(:extract))
        end

        def extract(data)
          raise StandardError, "No extractor instructions given - key => :extractors" if data[:extractors].blank?

          extractions = {}
          data[:extractors].each do |extractor_name, opts|
            next unless valid_extractor?(extractor: extractor_name)
            opts ||= {}

            # @todo: refactor so that an extractor name references a list of extractors
            #       - this can be used to specify multiple rules for extraction
            #       - specifically for crawls, we can specify rules for specific pages (it will be run on every page, which
            #         for now is fine)
            extractions[extractor_name] = EXTRACTORS[extractor_name].extract(url: data[:url], document: data[:document], **opts)
          end

          data.merge!({ extractions: extractions })
        end

        def valid_extractor?(extractor:)
          EXTRACTORS.include? extractor
        end
      end

      included do
        # @see {Fetchable#fetchable} for why this is necessary as an instance methods
        def extractable
          self.class.extractable
        end

        # @see {Fetchable#fetch} for why this is necessary as an instance method
        def extract(document)
          self.class.extract document
        end
      end
    end
  end
end
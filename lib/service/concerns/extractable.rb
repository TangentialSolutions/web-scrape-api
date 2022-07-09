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
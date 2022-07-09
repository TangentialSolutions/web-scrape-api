module Service
  class Scraper < Base
    include ::Service::Concerns::Fetchable
    include ::Service::Concerns::Parsable
    include ::Service::Concerns::Extractable

    attr_accessor :result, :persistance

    def initialize(url:, extractors:, persistance: :database)
      super(url: url, extractors: extractors)

      @result = nil
      @persistance = persistance
    end

    def exec
      @result = (fetchable >> parsable >> extractable).call({ url: url, extractors: extractors } )

      flush(format: persistance)
    end
  end
end
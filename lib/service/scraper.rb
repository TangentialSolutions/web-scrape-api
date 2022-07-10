module Service
  class Scraper < Base
    include ::Service::Concerns::Fetchable
    include ::Service::Concerns::Parsable
    include ::Service::Concerns::Extractable

    attr_accessor :result, :persistence

    def initialize(url:, extractors: {}, persistence: :database)
      super(url: url, extractors: extractors)

      @result = nil
      @persistence = persistence
    end

    def exec
      @result = (fetchable >> parsable >> extractable).call({ url: url, extractors: extractors } )

      flush(format: persistence)
    end
  end
end
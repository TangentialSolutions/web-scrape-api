module Service
  class Crawler < Scraper
    SUPPORTED_PERSISTENCE_METHODS = [:database]

    attr_reader :recrawl

    def initialize(url:, extractors: {}, persistence: :database, recrawl: false)
      super(url: url, extractors: extractors, persistence: persistence)

      @recrawl = recrawl
    end

    def exec
      super

      validate_persistence

      result[:extractions].each do |link|
        canonical_uri = URI.parse url
        link_uri = URI.parse link.url
        next unless canonical_uri.host&.downcase == link_uri.host&.downcase

        if recrawl || Link.where(url: link.url).count <= 1
          WebCrawlJob.perform_later(url: link.url)
        end
      end
    end

    private

    def validate_persistence
      raise StandardError, "Unsupported persistence type: must be :database to use Service::Crawler" unless persistence_supported?
    end

    def persistence_supported?
      SUPPORTED_PERSISTENCE_METHODS.include?(persistence)
    end
  end
end


module Service
  class Crawler < Scraper
    def exec
      super

      result[:extractions].each do |link|
        canonical_uri = URI.parse url
        link_uri = URI.parse link.url
        next unless canonical_uri.host.downcase == link_uri.host.downcase

        WebCrawlJob.perform_later(url: link.url)
      end
    end
  end
end


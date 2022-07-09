class WebCrawlJob < ApplicationJob
  queue_as :crawlers

  def perform(url:)
    Service::Crawler.new(url: url, extractors: {
      links: {
        context: "//a",
        replace: true
      }
    }).exec
  end
end

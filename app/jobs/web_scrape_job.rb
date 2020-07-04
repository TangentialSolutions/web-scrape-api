class WebScrapeJob < ApplicationJob
  queue_as :default

  def perform(url:)
    Service::Scraper.new(url: url, extractors: {
      links: {
        context: "//a[contains(@class, 'grid-product__image-link')]",
        replace: true
      },
      images: {
        context: "//div[@class='product--wrapper']"
      }
    }).exec
  end
end

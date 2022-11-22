module Api
  class ScrapeController < ApplicationController
    def get
      # WebScrapeJob.perform_later(url: site_url_param)
      Service::Scraper.new(url: site_url_param, extractors: {
        links: {
          context: "//a[contains(@class, 'product-card__link')]",
          replace: true
        }
      }).exec
      # @todo: Provide up-to-date execution status
      render json: {status: :executing}
    end

    private

    def site_url_param
      params[:url]
    end
  end
end

module Api
  class ScrapeController < ApplicationController
    PAUSE_WORKERS_KEY = "pause-all-workers"
    PAUSE_WORKERS_VALUE = true

    def get
      WebScrapeJob.perform_later(url: site_url_param)

      # @todo: Provide up-to-date execution status
      render json: {status: :executing}
    end

    def unpause
      Resque.redis.del(PAUSE_WORKERS_KEY)
    end

    def pause
      Resque.redis.set(PAUSE_WORKERS_KEY, PAUSE_WORKERS_VALUE)
    end

    private

    def site_url_param
      params[:url]
    end
  end
end

module Api
  class ResqueController < ApplicationController
    PAUSE_WORKERS_KEY = "pause-all-workers"
    PAUSE_WORKERS_VALUE = true

    def unpause
      Resque.redis.del(PAUSE_WORKERS_KEY)
    end

    def pause
      Resque.redis.set(PAUSE_WORKERS_KEY, PAUSE_WORKERS_VALUE)
    end
  end
end


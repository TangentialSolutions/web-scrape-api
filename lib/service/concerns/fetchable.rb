module Service
  module Concerns
    module Fetchable
      extend ActiveSupport::Concern

      class_methods do
        # Creates a Proc using the method extractor. The `:fetch` method must be an instance method for this methodology
        # to work.
        #
        # @see Object#method
        def fetchable
          # @todo: Could refactor this (I think) to just `method(:fetch).to_proc`
          Proc.new(&method(:fetch))
        end

        # Executes a simple GET request to the provided url.
        def fetch(data)
          data[:stringify] ||= true
          response = Faraday.get data[:url]

          if (response.status == 200 && data[:stringify])
            return data.merge!({ url: data[:url], markup: response.body })
          end

          ""
        end
      end

      included do
        self.attr_reader :markup


        # Proxy to the class method
        #
        # @note This was added to make a more fluid interface in the {Scraper} class so that we don't have to do a
        # `self.class.fetchable`
        #
        # @see Scraper#exec
        def fetchable
          self.class.fetchable
        end

        # Proxies to the class method, but is necessary so that {#fetchable} can use the {Object#method} feature to build
        # a Proc object
        def fetch(stringify = true, url)
          @markup = self.class.fetch(stringify, url)
        end
      end
    end
  end
end
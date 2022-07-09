module Service
  module Concerns
    module Parsable
      extend ::ActiveSupport::Concern

      class_methods do
        def parsable
          Proc.new(&method(:parse))
        end

        def parse(data)
          data.merge!({ document: Nokogiri::HTML.parse(data[:markup]) })
        end
      end

      included do
        # @see {Fetchable#fetchable} for why this is necessary as an instance methods
        def parsable
          self.class.parsable
        end

        # @see {Fetchable#fetch} for why this is necessary as an instance method
        def parse(markup)
          self.class.parse markup
        end
      end
    end
  end
end
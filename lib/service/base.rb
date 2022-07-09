require "json"

module Service
  class Base
    DATA_DIR = Rails.root.join("storage/data").freeze
    FORMATS = [:json, :database]

    attr_reader :url, :extractors

    def initialize(url:, extractors:)
      @url = url
      @extractors = extractors
    end

    def flush(format: :json, data: result)
      return unless FORMATS.include? format

      case format
      when :json
        flush_json(data: data)
      when :database
        flush_database(data: data)
      end
    end

    def filename_by_url
      parts = URI.parse(url)

      parts.host.gsub(".", "")
    end

  private

    def flush_json(data:)
      File.open("#{DATA_DIR}/#{filename_by_url}.json", "w") do |f|
        f.puts data.to_json
      end
    end

    def flush_database(data:)
      scrape = Scrape.create!({
        name: url,
        url: url,
        site_name: "",
        links: data[:extractions][:links]
      })

      # images: data[:extractions][:images],
      # scrape.links.create(data[:extractions][:links])
    end
  end
end
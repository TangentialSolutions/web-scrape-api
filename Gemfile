source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.3"

gem "rails", "~> 6.0.2", ">= 6.0.2.2"
gem "puma", "~> 4.1"
gem "faraday"
gem "nokogiri"
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "interactor", "~> 3.1"
gem "view_component", "~> 2.7"
gem "resque", "~> 2.0"
gem "mongoid", "~> 7.1"
gem "webpacker", "~> 5.1"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "dotenv-rails"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "pry"
end

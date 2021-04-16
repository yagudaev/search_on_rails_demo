source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.1'

# Core Rails
gem 'bootsnap', '>= 1.4.4', require: false
gem 'jbuilder', '~> 2.7'
gem 'pg', '~> 1.2.3'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.1'
gem 'sass-rails', '>= 6'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 5.0'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Data exploration
gem 'activeadmin'
gem 'devise', '~> 4.7'
gem 'forty_facets', github: 'yagudaev/forty_facets', branch: 'optimize-facets-speed'
gem 'pagy'
gem 'ransack'
gem 'searchjoy'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'pry'

  gem 'spring'
  gem 'web-console', '>= 4.1.0'

  # profiling
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'stackprof'
end

group :production do
  # montoring
  gem 'newrelic_rpm'
  gem 'newrelic-infinite_tracing'
  gem 'skylight'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development, :test do
  gem 'rspec-rails'
end

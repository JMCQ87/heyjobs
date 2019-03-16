source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.1'

gem 'activesupport', '~> 5.2.2.1'

gem 'faraday', '~> 0.15.4'          # Most common HTTP Client gem

group :development do
  gem 'rubocop', '~> 0.65.0', require: false
end

# For Debugging
group :development, :test do
  gem 'pry', '~> 0.12.2'
end

# For Testing
group :test do
  gem 'rspec', '~> 3.8.0'
end

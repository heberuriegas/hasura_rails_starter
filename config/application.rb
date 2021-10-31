require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HasuraRailsStarter
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Set sidekiq as default active job adapter
    config.active_job.queue_adapter = :sidekiq
  end
end

# Load actions
Rails.application.reloader.to_prepare do
  Dir.glob('app/actions/**/*.rb').each do |model|
    model.gsub('app/actions/', '').gsub('.rb', '').titleize.gsub(' ', '').gsub('/', '::').constantize
  end
end
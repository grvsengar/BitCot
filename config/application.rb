require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module OdinFacebook
  class Application < Rails::Application
    config.load_defaults 6.0
    config.assets.initialize_on_precompile = false

    # Set the default protect_from_forgery behavior
    config.action_controller.default_protect_from_forgery = true

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end


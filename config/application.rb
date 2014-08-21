require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'bootstrap-sass'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require File.expand_path('./config/settings.rb')

module Mice3
  class Application < Rails::Application
    Settings.load_config

    config.from_file 'settings.yml'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en
    config.i18n.available_locales =  ["en"]
    config.i18n.fallbacks = false

    config.autoload_paths << Rails.root.join('lib')

    config.assets.initialize_on_precompile = false
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
  end
end

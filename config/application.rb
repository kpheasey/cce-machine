require File.expand_path('../boot', __FILE__)

require 'rails/all'

require 'mtgox'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module BtcMarketExchange
  class Application < Rails::Application

  end
end

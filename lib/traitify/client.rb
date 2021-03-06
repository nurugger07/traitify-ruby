# require base modules
require "traitify/connection"
require "traitify/request"
require "hashie"
# require client modules in lib/Traitify/client
Dir[File.expand_path("../client/*.rb", __FILE__)].each {|f| require f }

module Traitify
  class Client
    attr_accessor(*Configuration::VALID_OPTIONS_KEYS)

    def initialize(options = {})
      options = Traitify.options.merge(options)

      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    include Traitify::Connection
    include Traitify::Configuration
    include Traitify::Request

    include Traitify::Client::Deck
    include Traitify::Client::Assessment
    include Traitify::Client::Slide
    include Traitify::Client::Result
  end
end

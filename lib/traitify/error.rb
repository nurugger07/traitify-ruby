require "pry"
module Traitify
  class Error < StandardError
    attr_accessor :response

    def self.from(status)
      if klass = case status
                 when 400 then Traitify::BadRequest
                 when 401 then Traitify::Unauthorized
                 when 404 then Traitify::NotFound
                 when 422 then Traitify::UnprocessableEntity
                 end

        klass.new(response)
      end
    end

    def initialize(response)
      @response = response
      super(error_message)
    end

    def errors
      response.body
    end

    private
    def error_message
      message =  "#{response.env[:method].upcase} | "
      message << "#{response.env[:url].to_s} | "
      message << "#{response.status} | "
      message << "#{response.body}"
      message
    end
  end

  class BadRequest < Error; end
  class Unauthorized < Error; end
  class NotFound < Error; end
  class UnprocessableEntity < Error; end
end

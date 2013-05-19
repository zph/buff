require "faraday"
require "faraday_middleware"
require "json"
require "rash"

require "buff/version"
require "buff/core"
require "buff/user"
require "buff/profile"
require "buff/update"
require "buff/link"
require "buff/error"
require "buff/encode"

module Buff

  begin
    ACCESS_TOKEN = File.open(File.expand_path("~/.bufferapprc")).readlines[2].chomp if File.exists?(File.expand_path("~/.bufferapprc"))
  end

  class UserInfo < Hashie::Mash; end
  class Profile  < Hashie::Mash; end
  class Response < Hashie::Mash; end
  class Update   < Hashie::Mash; end
  class Updates  < Hashie::Mash; end
  class Interaction < Hashie::Mash; end
  class Interactions < Hashie::Mash; end
  class Link < Hashie::Mash; end
  class Info < Hashie::Mash; end

  class Schedule < Hashie::Mash; end
  Schedules = Class.new(Array) do
    def dump
      { schedules: self }.to_json
    end
  end

  InvalidIdLength = Class.new(ArgumentError)
  InvalidIdContent = Class.new(ArgumentError)
  MissingStatus = Class.new(ArgumentError)
  APIError = Class.new(StandardError)
  UnauthorizeRequest = Class.new(StandardError)

  class Client
    include Core
    include User
    include Profile
    include Update
    include Link
    include Error

    attr_accessor :access_token, :auth_query

    def initialize(access_token)
      @access_token = access_token
      self.class.default_params :access_token => access_token
      @conn = Faraday.new(:url => "https://api.bufferapp.com/1/") do |faraday|
          faraday.request  :url_encoded             # form-encode POST params
          faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    def auth_query
      { :access_token => @access_token }
    end

    def info
      response = get("/info/configuration.json")
      Buff::Info.new(response)
    end
  end
end


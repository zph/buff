require "httparty"
require "json"
require "rash"

require "buff/version"
require "buff/core"
require "buff/user"
require "buff/profile"
require "buff/update"

module Buff

  class UserInfo < Hashie::Mash; end
  class Profile  < Hashie::Mash; end
  class Response < Hashie::Mash; end
  class Update   < Hashie::Mash; end
  class Updates  < Hashie::Mash; end
  class Interaction < Hashie::Mash; end
  class Interactions < Hashie::Mash; end

  class Schedule < Hashie::Mash; end
  Schedules = Class.new(Array) do
    def dump
      { schedules: self }.to_json
    end
  end

  InvalidIdLength = Class.new(ArgumentError)
  InvalidIdContent = Class.new(ArgumentError)
  MissingStatus = Class.new(ArgumentError)

  class Client
    include HTTParty
    include Core
    include User
    include Profile
    include Update

    attr_accessor :access_token, :auth_query

    base_uri "https://api.bufferapp.com/#{API_VERSION}"

    def initialize(access_token)
      @access_token = access_token
      @auth_query = {
        :query => {
        'access_token' => access_token
        }
      }
    end
  end
end


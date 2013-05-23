module Buff
  class Client
    include Core
    include User
    include Profile
    include Update
    include Link
    include Info

    attr_accessor :access_token

    def initialize(access_token)
      @access_token = access_token
      url = "https://api.bufferapp.com/1/"
      @connection = Faraday.new(:url => url) do |faraday|
        faraday.request  :url_encoded
        faraday.adapter  Faraday.default_adapter
      end
    end

    def auth_query
      { :access_token => @access_token }
    end

  end
end

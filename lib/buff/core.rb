
module Buff
  begin
    if File.exists?(File.expand_path("~/.bufferapprc"))
      ACCESS_TOKEN = File.open(File.expand_path("~/.bufferapprc")).
        readlines[2].chomp
    end
  end

  class Client
    module Core
      API_VERSION = "1"

      attr_reader :error_table


      def get(path, options={})
        options.merge!(auth_query)
        response = @connection.get do |req|
          req.url path.gsub(%r{^\/}, '')
          req.params = options
        end

        interpret_response(response)
      end

      def post(path, options={})
        params = merge_auth_token_and_query(options)
        @connection.post do |req|
          req.url path.remove_leading_slash
          req.headers['Content-Type'] = "application/x-www-form-urlencoded"
          req.body = options[:body]
          req.params = params
        end
      end


      def merge_auth_token_and_query(options)
        if options[:query]
          auth_query.merge options[:query]
        else
          auth_query
        end
      end

      def interpret_response(response)
        if response.status == 200
          JSON.parse response.body
        else
          handle_response_code(response)
        end
      end

      def handle_response_code(response)
        error = Hashie::Mash.new( response.body )
        raise Buff::APIError unless error.code
        error_explanation = "Buffer API Error Code: #{error.code}\n" +
                            "HTTP Code: #{response.code}." +
                            "Description: #{error.error}"
      end
    end
  end
end

class String
  def remove_leading_slash
    gsub(%r{^\/}, '')
  end
end

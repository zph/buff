module Buff
  class Client
    module Info
      def info
        response = get("/info/configuration.json")
        Buff::Info.new(response)
      end
    end
  end
end

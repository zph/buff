module Buff
  class Client
    module Core
      API_VERSION = "1"

      def get(path, options=auth_query)
        self.class.get(path, options)
      end
    end
  end
end

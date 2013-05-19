module Buff
  class Client
    module Link
      def link(options)
        response = get("/links/shares.json", options)
        Buff::Link.new(response)
      end
    end
  end
end

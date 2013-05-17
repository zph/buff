module Buff
  class Client
    module Link
      def link(url)
        response = get("/links/shares.json?url=#{url}")
        Buff::Link.new(response)
      end
    end
  end
end

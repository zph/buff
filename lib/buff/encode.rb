module Buff
  class Encode
    def self.encode(arg)
      if arg.respond_to?(:keys)
        arg = arg[:schedules]
      end

      output = []
      arg.each_with_index do |item, index|
        uri = Addressable::URI.new
        uri.query_values = item
        pairs = uri.query.split("&").map do |pair|
          key , value = pair.split("=")
          "schedules[#{index}][#{key}][]=#{value}"
        end
        output << pairs.join("&")
      end
      output.join("&")
    end
  end
end

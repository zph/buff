module Buff
  class Encode
    def self.encode(arg)
      raise_error_for_incorrect_input(arg)
      arg = arg[:schedules] if arg.respond_to?(:keys)
      output = []
      arg.each_with_index do |item, index|
        process_schedule(output, item, index)
      end
      output.join("&")
    end

    private

    def self.raise_error_for_incorrect_input(arg)
      unless arg.kind_of?(Hash) || arg.kind_of?(Array)
        raise ArgumentError, "Input must be/inherit from Hash or Array"
      end
    end

    def self.process_schedule(output, item, index)
      uri = Addressable::URI.new
      uri.query_values = item
      pairs = uri.query.split("&").map do |pair|
        key , value = pair.split("=")
        "schedules[#{index}][#{key}][]=#{value}"
      end
      output << pairs.join("&")
    end
  end
end

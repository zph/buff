module Buff
  InvalidIdLength = Class.new(ArgumentError)
  InvalidIdContent = Class.new(ArgumentError)
  MissingStatus = Class.new(ArgumentError)
  APIError = Class.new(StandardError)
  UnauthorizeRequest = Class.new(StandardError)
end

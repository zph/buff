module Buff
  #TODO: refactor errors into Error Module and fix references
  InvalidIdLength = Class.new(ArgumentError)
  InvalidIdContent = Class.new(ArgumentError)
  MissingStatus = Class.new(ArgumentError)
  APIError = Class.new(StandardError)
  UnauthorizeRequest = Class.new(StandardError)

  module Error
    ConfigFileMissing = Class.new(StandardError)
  end
end

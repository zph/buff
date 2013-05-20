require 'buff'
require 'rspec'
require 'webmock/rspec'
require 'json'

require 'coveralls'
Coveralls.wear!

def fixture_path
  File.expand_path(File.join("..", "fixtures"), __FILE__)
end

def fixture(file)
  File.new(File.join(fixture_path, file))
end

def post_data
<<EOF
schedules[0][days][]=mon&schedules[0][days][]=tue&schedules[0][days][]=wed&schedules[0][times][]=12:00&schedules[0][times][]=17:00&schedules[0][times][]=18:00&
EOF
end

def sample_schedules2
    [{ days: %w[mon tue wed],
      times: %w[12:00 17:00 18:00]},
      {days: %w[mon tue wed],
      times: %w[12:00 17:00 18:00]},
    ]

end

def base_path
  "https://api.bufferapp.com/1"
end

def access_token_param
  "access_token=some_token"
end

def stub_with_to_return(request_type, url, fixture_name, query_hash={})
  query = access_hash.merge(query_hash)
  stub_request(request_type, url).
     with(query: query).
     to_return(fixture(fixture_name))
end

def access_hash
  { 'access_token' => 'some_token'}
end

def sample_schedules
  [
    [{ days: %w[mon tue wed],
      times: %w[12:00 17:00 18:00]}]
  ]
  # @sample_schedules = JSON.parse <<EOF
  #   [{
  #       "days" : [
  #           "mon",
  #           "tue",
  #           "wed",
  #           "thu",
  #           "fri"
  #       ],
  #       "times" : [
  #           "12:00",
  #           "17:00",
  #           "18:00"
  #       ]
  #   },
  #   {
  #           "days" : [
  #               "mon",
  #               "tue",
  #               "wed",
  #               "thu",
  #               "fri"
  #           ],
  #           "times" : [
  #               "12:00",
  #               "17:00",
  #               "18:00"
  #           ]
  #       }]
# EOF
end


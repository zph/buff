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


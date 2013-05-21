require 'spec_helper'

describe Buff::Schedules do
  before do
    @schedule = JSON.parse <<EOF
    {
            "days" : [
                "mon",
                "tue",
                "wed",
                "thu",
                "fri"
            ],
            "times" : [
                "12:00",
                "17:00",
                "18:00"
            ]
        }
EOF

    @sample_schedules = JSON.parse <<EOF
    { "schedules" : [{
        "days" : [
            "mon",
            "tue",
            "wed",
            "thu",
            "fri"
        ],
        "times" : [
            "12:00",
            "17:00",
            "18:00"
        ]
    },
    {
            "days" : [
                "mon",
                "tue",
                "wed",
                "thu",
                "fri"
            ],
            "times" : [
                "12:00",
                "17:00",
                "18:00"
            ]
        }]
    }
EOF
  end

  it "accepts an array of days" do
    lambda {
      schedules = Buff::Schedules.new
      schedules << Buff::Schedule.new
    }.should_not raise_error
  end

  it "dumping a double schedule yields correct json" do
    schedules = Buff::Schedules.new
    schedules << @schedule << @schedule
    @sample_schedules = @sample_schedules.to_json

    schedules.dump.should eq(@sample_schedules)
  end

  describe "#set_schedules" do
    xit "throw error if schedules is empty" do
      lambda {
        Buff::Client.new("some_token").set_schedules(id) }.
      should raise_error(ArgumentError)

    end
  end
end


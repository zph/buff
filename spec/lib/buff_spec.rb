require 'spec_helper'


describe Buff::Client do
  let(:id) { "5160746d54f04a5e3a00000f" }

  subject do
    Buff::Client.new("some_token")
  end

  describe "#initialize" do
    it "allows a token to be set and retrieved" do
      subject.access_token.should eq("some_token")
    end
  end

  describe "#user_info" do
    let(:rash) { subject.user_info }

    before(:each) do
      url = "#{ base_path }/user.json"
      stub_with_to_return(:get, url, "user_authenticated.txt")
    end

    it "returns a Rash object" do
      rash.class.should eq(Buff::UserInfo)
    end

    it "provides an accessor for plan" do
      rash.plan.should eq("free")
    end
  end

  describe "#profiles" do
    let(:rash) { Buff::Client.new("some_token").profiles }

    before(:each) do
      url = "#{ base_path }/profiles.json"
      stub_with_to_return(:get, url, 'profile_authenticated.txt')
    end

    it "makes the correct url request" do
      subject.profiles
    end

    it "returns a Rash collection object" do
      rash[0].class.should eq(Buff::Profile)
    end

    it "provides an accessor for plan" do
      rash[0].service.should eq("twitter")
    end
  end

  describe "#profile_by_id" do
    let(:id) { "5160746d54f04a5e3a00000f" }
    before(:each) do
      url = "#{base_path}/profiles/#{id}.json"
      fixture_name = "profiles_by_id.txt"
      stub_with_to_return(:get, url, fixture_name)
    end

    let(:rash) { Buff::Client.new("some_token").profile_by_id(id) }

    it "returns a rash collection" do
      rash.class.should eq(Buff::Profile)
    end

    it "accesses formatted service" do
      rash.formatted_service.should eq("Twitter")
    end
  end

  describe "#profile_schedules_by_id" do
    before(:each) do
      url = "#{base_path}/profiles/#{id}/schedules.json"
      fixture_name = 'profile_schedules_by_id.txt'
      stub_with_to_return(:get, url, fixture_name)
    end

    let(:rash) { Buff::Client.new("some_token").profile_schedules_by_id(id) }

    it "returns a rash collection" do
      rash[0].class.should eq(Buff::Schedule)
    end

    it "accesses days" do
      expect(rash[0].days).to include("mon")
    end

    it "accesses times" do
      expect(rash[0].times).to include("06:13")
    end
  end

  describe "#set_schedules" do
    #not yet implemented
    xit "throw error if schedules is empty" do
      lambda {
        Buff::Client.new("some_token").set_schedules(id) }.
      should raise_error(ArgumentError)

    end
  end

  describe "#info" do
    before do
      stub_request(:get, "#{base_path}/info/configuration.json?access_token=some_token").
        to_return(fixture("info.txt"))
    end

    it "connects to the correct endpoint" do
      subject.info
    end

    it "retrieves the correct name" do
      subject.info.services.twitter.types.profile.name.should eq("Twitter")
    end
  end
end

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
end

describe Buff::Client::Core do

  let(:client) { Buff::Client.new("some_token") }
  describe "#get" do
    it "delegates to #handle_response_code when code != 200" do
       stub_request(:get, "#{base_path}/info/configuration.json?access_token=some_token").
         to_return(:status => 403, :body => "", :headers => {})
       client.should_receive(:handle_response_code).once
       client.info
    end


    it "does not delegate to #handle_response_code when code = 200" do
       stub_request(:get, "#{base_path}/info/configuration.json?access_token=some_token").
         to_return(fixture("link.txt"))
       client.should_not_receive(:handle_response_code)
       client.info
    end
  end

  describe "#post" do

    it "connects to the correct endpoint" do

    #TODO improve test
      response = %Q[{"success": true, "message": "Schedule saved successfully"}]
      id = "4eb854340acb04e870000010"
      stub_request(:post, %r{https://api\.bufferapp\.com/1/profiles/4eb854340acb04e870000010/schedules/update\.json\?access_token=.*}).
               with(:body => {"schedules"=>{"days"=>["mon", "tue", "wed"], "times"=>["12:00", "17:00", "18:00"]}},
                    :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.8.7'}).
               to_return(:status => 200, :body => response, :headers => {})
       client.set_schedules(id, :schedules => sample_schedules).success.
         should eq(true)
    end

    xit "does not delegate to #handle_response_code when code = 200" do
      url = "#{base_path}/info/configuration.json"
      fixture_name = "link.txt"
      stub_with_to_return(:get, url, fixture_name)
       client.should_not_receive(:handle_response_code)
       client.info
    end

    xit "transforms sample_schedule into correct formatted url" do
      u = Addressable::URI.new
      u.query_values = {schedules: sample_schedules[0]}
      u.query.should eq(post_data)
    end
  end

  describe "#handle_response_code" do
    context "fails gracefully with undocumented responses" do
      it "responds to 401 unauthorized response" do
        id = "4eb8565e0acb04bb82000004"
        url = "#{base_path}/updates/#{id}.json?access_token=some_token"
        stub_with_to_return(:get, url, "update_by_id_non_auth.txt")
        lambda { client.update_by_id(id) }.
          should raise_error(Buff::APIError)
      end
    end
  end

  describe "error_table" do
    it "should report 1001 as appropriate message" do
      table = Buff::Client::Core.error_table
      table['1001'].should eq("Access token required.")
    end
  end
end

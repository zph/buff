require 'spec_helper'

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
      stub_request(:post, "#{ base_path }/profiles/#{id}/schedules/update.json?access_token=some_token").
         with(:body => {"schedules"=>"schedules[0][days][]=mon&schedules[0][days][]=tue&schedules[0][days][]=wed&schedules[0][times][]=12%3A00&schedules[0][times][]=17%3A00&schedules[0][times][]=18%3A00"},
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.8.7'}).
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

end

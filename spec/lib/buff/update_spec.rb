require 'spec_helper'

describe Buff::Client do
  let(:client) { Buff::Client.new("some_token") }
  let(:profile_id) { "4eb854340acb04e870000010" }
  let(:id) { "4eb8565e0acb04bb82000004" }

  describe "updates" do
    describe "#update_by_id" do

      before do
        stub_request(:get, "https://api.bufferapp.com/1/updates/4eb8565e0acb04bb82000004.json?access_token=some_token").
                 to_return(fixture("update_by_id.txt"))
      end
      it "fails without an id" do
        lambda {
          update = client.update_by_id}.
          should raise_error(ArgumentError)
      end

      it "connects to the correct endpoint" do
        client.update_by_id(id)
      end

      it "returns a well formed update rash" do
        client.update_by_id(id).sent_at.should eq(1320744001)
      end

    end


    describe "#updates_by_profile_id" do
      it "requires an id arg" do
        lambda { client.updates_by_profile_id }.
          should raise_error(ArgumentError)
      end

      it "fails without a :status arg" do
        lambda { client.updates_by_profile_id(profile_id)}.
          should raise_error(Buff::MissingStatus)
      end

      it "connects to the correct endpoint" do
        url = "https://api.bufferapp.com/1/profiles/4eb854340acb04e870000010/updates/pending.json?access_token=some_token"

        stub_request(:get, url).
          to_return(fixture('updates_by_profile_id_pending.txt'))
        client.updates_by_profile_id(profile_id, status: :pending).
          total.should eq(1)
      end

      it "utilizes the optional params" do
        url = "https://api.bufferapp.com/1/profiles/4eb854340acb04e870000010/updates/pending.json?access_token=some_token&count=3&page=2"

        stub_request(:get, url).
          to_return(fixture('updates_by_profile_id_pending.txt'))
        client.updates_by_profile_id(profile_id, status: :pending, page: 2, count: 3).
          total.should eq(1)
      end
    end

    describe "#interactions_by_update_id" do
      let(:url) { "https://api.bufferapp.com/1/updates/4ecda476542f7ee521000006/interactions.json?access_token=some_token&page=2" }
      let(:id) { "4ecda476542f7ee521000006" }

      before do
        stub_request(:get, url).
          to_return(fixture("interactions_by_update_id.txt"))
      end

      it "requires an id" do
        lambda { client.interactions_by_update_id(page: 2) }.
          should raise_error(Buff::InvalidIdLength)
      end

      it "allows optional params" do
        client.interactions_by_update_id(id, page: 2)
      end
    end

    describe "#check_id" do
      it "fails if id is not 24 chars" do
        stub_request(:get, "https://api.bufferapp.com/1/updates/4eb8565e0acb04bb82000004X.json?access_token=some_token").
                 to_return(:status => 200, :body => "", :headers => {})
        id = "4eb8565e0acb04bb82000004X"
        lambda { client.update_by_id(id) }.
          should raise_error(Buff::InvalidIdLength)
      end

      it "fails if id is not numbers and a-f" do
        stub_request(:get, "https://api.bufferapp.com/1/updates/4eb8565e0acb04bb8200000X.json?access_token=some_token").
                 to_return(:status => 200, :body => "", :headers => {})
        id = "4eb8565e0acb04bb8200000X"
        lambda { client.update_by_id(id) }.
          should raise_error(Buff::InvalidIdContent)
      end
    end

    describe "#reorder_updates" do
      it "connects to appropriate endpoint" do
        id_no = "4ecda256512f7ee521000001"
        order_hash = { order: [id_no, id_no, id_no] }
        stub_request(:post, %r{https://api\.bufferapp\.com/1/profiles/4ecda256512f7ee521000001/updates/reorder\.json\?access_token=.*}).
                   with(:body => {"order"=>["4ecda256512f7ee521000001", "4ecda256512f7ee521000001", "4ecda256512f7ee521000001"]},
                        :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.8.7'}).
                   to_return(:status => 200, :body => "", :headers => {})
        client.reorder_updates(id_no, order_hash)

      end
    end

    describe "#shuffle_updates" do
      it "connects to appropriate endpoint" do
        id_no = "4ecda256512f7ee521000001"
        stub_request(:post, %r{https://api\.bufferapp\.com/1/profiles/4ecda256512f7ee521000001/updates/shuffle\.json\?access_token=.*}).
                 with(:body => {"count"=>"10"})
        client.shuffle_updates(id_no, count: 10)
      end
    end
    describe "#share_update" do
      it "should connect to correct endpoint" do
        stub_request(:post, %r{https://api\.bufferapp\.com/1/updates/4ecda256512f7ee521000001/share\.json\?access_token=.*}).
           to_return(:status => 200, :body => "{'success': true}", :headers => {})
        update_id = "4ecda256512f7ee521000001"
        client.share_update(update_id)
      end
    end

    describe "#destroy_update" do
      it "connects to correct endpoint" do
        stub_request(:post, %r{https://api\.bufferapp\.com/1/updates/4ecda256512f7ee521000001/destroy\.json\?access_token=.*}).
           to_return(fixture('destroy.txt'))
             update_id = "4ecda256512f7ee521000001"
        client.destroy_update(update_id)
      end
    end
  end
end

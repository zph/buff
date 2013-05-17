require 'spec_helper'

describe Buff::Client do
  describe "#link" do
    let(:client) { Buff::Client.new("some_token") }
    let(:url) { %q{http://bufferapp.com} }

    before do
      stub_request(:get, "https://api.bufferapp.com/1/links/shares.json?access_token=some_token&url=http://bufferapp.com").
        to_return(fixture('link.txt'))
    end

    it "connects to the correct endpoint" do
      client.link(url)
    end

    it "parses the shares of a link" do
      client.link(url).shares.should eq(47348)
    end

  end
end

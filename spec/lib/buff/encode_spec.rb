require "spec_helper"

describe Buff::Encode do
  describe "#encode" do

    let(:uri) { Addressable::URI.new }
    it "throws error unless input is a hash" do
      lambda { Buff::Encode.encode([]) }.
        should raise_error(ArgumentError)
    end

    it "should convert {:pony => 'pony' }" do
      h = { pony: "pony"}
      uri.query_values = h
      uri.query.should eq("pony=pony")
    end

    it "should convert {:pony => ['pony', 'horse'] }" do
      h = { pony: ["pony", "horse"]}
      uri.query_values = h
      uri.query.should eq("pony=pony&pony=horse")
    end

    it "should convert {:days => [mon, tues], :times => [....]}" do
      h = { days: ["mon", "tue"], times: ["12:00", "13:00"]}
      uri.query_values = h
      uri.query.should eq("days=mon&days=tue&times=12%3A00&times=13%3A00")
    end
    xit "should convert {schedules => {:days => [mon, tues], :times => [....]}" do
      # h = { :days => ["mon", "tue", "wed", "thu"], :times => ["12:00", "13:00"]}
      h = {:a => "a", :bd => ["c", "d", "e"]}
      uri.query_values = h
      uri.query.should eq("days=mon&days=tue&times=12%3A00&times=13%3A00")
    end
  end
end

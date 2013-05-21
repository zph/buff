require "spec_helper"

  # describe "Addressable Explorations" do

  #   describe "addressable conversions" do

  #     let(:uri) { Addressable::URI.new }

  #     it "should convert {:pony => 'pony' }" do
  #       h = { pony: "pony"}
  #       uri.query_values = h
  #       uri.query.should eq("pony=pony")
  #     end

  #     it "should convert {:pony => ['pony', 'horse'] }" do
  #       h = { pony: ["pony", "horse"]}
  #       uri.query_values = h
  #       uri.query.should eq("pony=pony&pony=horse")
  #     end

  #     it "should convert {:days => [mon, tues], :times => [....]}" do
  #       h = { days: ["mon", "tue"], times: ["12:00", "13:00"]}
  #       uri.query_values = h
  #       uri.query.should eq("days=mon&days=tue&times=12%3A00&times=13%3A00")
  #     end
  #     xit "should convert {schedules => {:days => [mon, tues], :times => [....]}" do
  #       h = { schedules: { :days => ["mon", "tue", "wed", "thu"], :times => ["12:00", "13:00"]} }
  #       # h = {:a => "a", :bd => ["c", "d", "e"]}
  #       uri.query_values = h
  #       uri.query.should eq("days=mon&days=tue&times=12%3A00&times=13%3A00")
  #     end
  #   end
describe Buff::Encode do

  context "successful code" do

  let(:schedule_first) { { :days => ["mon", "tue", "wed", "thu"], :times => ["12:00", "13:00"]} }
  let(:schedule_second) { { :days => ["sun", "sat"], :times => ["09:00", "24:00"]} }
  let(:schedules_hash) { { schedules: [schedule_first, schedule_second] } }
  let(:short_schedule) { { days: ["mon", "tue", "wed"], times: ["12:00", "17:00", "18:00"]} }
  let(:short_schedule_encoded) { "[days][]=mon&[days][]=tue&[times][]=12%3A00&[times][]=13%3A00" }
  let(:schedules_encoded) { "schedules[0][days][]=mon&schedules[0][days][]=tue&schedules[0][days][]=wed&schedules[0][times][]=12:00&schedules[0][times][]=17:00&schedules[0][times][]=18:00" }
  let(:very_short_schedule) { { :days => ["sun", "sat"], :times => ["09:00", "24:00"]} }


  describe "#encode"
    it "converts to match Buffer API specs encoding" do
      Buff::Encode.encode([short_schedule]).
        should eq(schedules_encoded.gsub(/:/, '%3A'))
    end

    it "processes an input array of schedules" do
      Buff::Encode.encode([very_short_schedule, very_short_schedule]).
        should eq("schedules[0][days][]=sun&schedules[0][days][]=sat&schedules[0][times][]=09%3A00&schedules[0][times][]=24%3A00&schedules[1][days][]=sun&schedules[1][days][]=sat&schedules[1][times][]=09%3A00&schedules[1][times][]=24%3A00")
    end

    it "includes index in conversion when multiple schedules present" do
      Buff::Encode.encode([very_short_schedule, very_short_schedule, very_short_schedule]).
        should eq("schedules[0][days][]=sun&schedules[0][days][]=sat&schedules[0][times][]=09%3A00&schedules[0][times][]=24%3A00&schedules[1][days][]=sun&schedules[1][days][]=sat&schedules[1][times][]=09%3A00&schedules[1][times][]=24%3A00&schedules[2][days][]=sun&schedules[2][days][]=sat&schedules[2][times][]=09%3A00&schedules[2][times][]=24%3A00")
    end

    it "processes an input hash" do
      Buff::Encode.encode({ schedules: [very_short_schedule, very_short_schedule, very_short_schedule] }).
        should eq("schedules[0][days][]=sun&schedules[0][days][]=sat&schedules[0][times][]=09%3A00&schedules[0][times][]=24%3A00&schedules[1][days][]=sun&schedules[1][days][]=sat&schedules[1][times][]=09%3A00&schedules[1][times][]=24%3A00&schedules[2][days][]=sun&schedules[2][days][]=sat&schedules[2][times][]=09%3A00&schedules[2][times][]=24%3A00")
    end
  end

  describe "#encode_schedule_primary" do
  end


end

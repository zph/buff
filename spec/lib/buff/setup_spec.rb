require "spec_helper"

describe Buff::Setup do

  let(:bad_config_setup) { Buff::Setup.new "~/notpresentexample" }
  let(:setup) { Buff::Setup.new }

  context "pathname" do
    it "sets the default path" do
      expect(setup.path).to eq("~/.bufferapprc")
    end unless travis?
  end
  context "verifies whether rc file exists" do
    it "fails with error when specified file not found" do
      lambda { bad_config_setup.path }.should
        raise_error(Buff::Error::ConfigFileMissing)
    end
    it "documents when rc file is present" do
      expect(setup.exists?).to eq(true)
    end unless travis?
  end
  context "determines if rc file is the most current version" do
    it "checks current RC_VERSION" do
      expect( Buff::RC_VERSION ).to_not eq(nil)
    end

    it "reports error when file is out of date" do
    end
    it "returns true when current"
  end
  context "when rc file is current"
    it "exits without altering state"
  context "when rc file is not present"
    it "verifies that rc file doesn't exist"
    it "creates an rc file and prompts for authorization"

  context "when rc file is out of date"
end

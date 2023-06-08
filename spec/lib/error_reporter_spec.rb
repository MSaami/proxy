require "rails_helper"

class DummyError < StandardError; end

RSpec.describe ErrorReporter do
  describe "instantiate" do
    it "it accepts an exception create an instance of log" do
      expect(Logger).to receive(:new).with("log/error_report.log")
      described_class.new(DummyError.new)
    end

    it "generates an uuid for each exception" do
      object = described_class.new(DummyError.new)
      expect(object.instance_variable_get(:@uuid)).not_to be_nil
    end
  end

  describe "#report" do
    it "writes to file" do
      expect_any_instance_of(Logger).to receive(:error)
      described_class.new(DummyError.new).report
    end
  end
end

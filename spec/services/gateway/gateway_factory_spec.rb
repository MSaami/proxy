require "rails_helper"

RSpec.describe Gateway::GatewayFactory do
  let(:message_mock) { double("message") }

  describe ".make_for" do
    it "accepts a message and return an teamtecture gateway" do
      allow(message_mock).to receive(:gateway).and_return(:teamtecture)
      expect(described_class.make_for(message_mock)).to be_a Gateway::TeamtectureGateway
    end

    it "accepts a message and return an slack gateway" do
      allow(message_mock).to receive(:gateway).and_return(:slack)
      expect(described_class.make_for(message_mock)).to be_a Gateway::SlackGateway
    end

    it "accepts a message and return an datev gateway" do
      allow(message_mock).to receive(:gateway).and_return(:datev)
      expect(described_class.make_for(message_mock)).to be_a Gateway::DatevGateway
    end

    it "throw an exception if handler not found" do
      allow(message_mock).to receive(:gateway).and_return(:dummy)
      expect { described_class.make_for(message_mock) }.to raise_error(HandlerNotFoundError)
    end
  end
end

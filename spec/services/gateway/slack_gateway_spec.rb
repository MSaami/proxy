require "rails_helper"

RSpec.describe Gateway::SlackGateway do
  let(:message_mock) { double("message") }

  describe "#publish" do
    it "publish to gateway" do
      expect(message_mock).to receive(:done_by_result).with({ "status"  => "200",
                                                              "message" => "Published to Slack" })
      described_class.new(message_mock).publish
    end
  end
end

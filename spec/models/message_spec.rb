require "rails_helper"

RSpec.describe Message, type: :model do
  include ActiveJob::TestHelper

  describe "validations" do
    it { should validate_presence_of(:gateway) }
    it { should define_enum_for(:status) }
    it { should define_enum_for(:gateway) }
    it do
      should define_enum_for(:status)
        .with_values(processing: 0, done: 1, failed: 2)
    end
    it do
      should define_enum_for(:gateway)
        .with_values(slack: 0, teamtecture: 1, datev: 2)
    end

    it { should validate_presence_of(:file) }
    it { is_expected.to validate_attached_of(:file) }
    it {
      is_expected.to validate_content_type_of(:file)
        .allowing("text/csv", "image/png", "application/pdf", "image/jpeg")
    }
  end

  describe "#publish" do
    it "publishes message and get done" do
      message = create(:message, gateway: :slack)
      expect { message.publish! }.to change { message.status }.from("processing").to("done")
    end

    it "publishes message and set result" do
      message = create(:message, gateway: :slack)
      expect { message.publish! }.to change { message.result }.from(nil)
    end

    it "set status failed by exception if has error" do
      message = create(:message, gateway: :slack)
      expect(Gateway::GatewayFactory).to receive(:make_for).with(message)
      expect { message.publish! }.to change { message.status }.from("processing").to("failed")
    end
  end

  describe ".after_create" do
    it "pushes to queue after create a message" do
      message = create(:message)
      assert_enqueued_with(job: MessageSenderJob, args: [message.id])
    end
  end

  describe "change status" do
    it "updates status to done with result" do
      message = create(:message)
      expect { message.done_by_result("Done") }.to change { message.done? }.to(true)
    end

    it "updates status to failed with result" do
      message = create(:message)
      expect { message.failed_by_exception("UUID") }.to change { message.failed? }.to(true)
    end
  end
end

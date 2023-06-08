require "rails_helper"

RSpec.describe MessageSenderJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later(1) }

  it "queues the job" do
    expect { job }
      .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end
  it "is in default queue" do
    expect(MessageSenderJob.new.queue_name).to eq("default")
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end

class MessageSenderJob < ApplicationJob
  queue_as :default

  def perform(message_id)
    Message.find(message_id).publish!
  end
end

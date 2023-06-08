class Api::V1::MessagesController < ApplicationController
  def create
    Message.create!(message_params)
  end

  private
  def message_params
    params.require(:message).permit(:gateway, :file, payload: {})
  end
end

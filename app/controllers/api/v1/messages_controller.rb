module Api
  module V1
    class MessagesController < ApplicationController
      def create
        Message.create!(message_params)
      end

      private

      def message_params
        params.require(:message).permit(:gateway, :file, payload: {})
      end
    end
  end
end

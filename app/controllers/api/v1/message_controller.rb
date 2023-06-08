module Api
  module V1
    class MessageController < ApplicationController
      def create
        Message.create!(message_params)
      end

      def index
        render json: {data: Message.all}
      end

      private

      def message_params
        params.require(:message).permit(:gateway, :file, payload: {})
      end
    end
  end
end

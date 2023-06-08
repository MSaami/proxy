require "rails_helper"

RSpec.describe "Api::V1::Messages", type: :request do
  describe "POST /store" do
    it "send a message to third party" do
      file = fixture_file_upload("spec/fixtures/image.jpeg")

      post "/api/v1/message", params: { message: { gateway: :slack, file: } }
      expect(response).to have_http_status(204)
      expect(Message.count).to eq(1)
    end

    it "gets validation error if data is incorrect" do
      file = fixture_file_upload("spec/fixtures/image.jpeg")

      post "/api/v1/message", params: { message: { gateway: :dummy, file: } }
      expect(response).to have_http_status(422)
      expect(json_body["errors"].key?("gateway")).to be true
    end

    it "stores the payload" do
      file = fixture_file_upload("spec/fixtures/image.jpeg")
      post "/api/v1/message",
           params: { message: { gateway: :slack, file:, payload: { message: "Hi" } } }
      expect(response).to have_http_status(204)
      expect(Message.last.payload).to eq({ "message" => "Hi" })
    end
  end
end

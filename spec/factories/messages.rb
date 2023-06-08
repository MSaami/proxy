FactoryBot.define do
  factory :message do
    gateway { "slack" }
    file { Rack::Test::UploadedFile.new("spec/fixtures/image.jpeg", "image/jpeg") }
  end
end

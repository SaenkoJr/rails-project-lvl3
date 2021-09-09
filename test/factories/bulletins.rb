# frozen_string_literal: true

FactoryBot.define do
  factory :bulletin do
    name
    description
    category_id { nil }

    factory :with_photo do
      photo { Rack::Test::UploadedFile.new('test/fixtures/files/image1.jpeg', 'image/jpeg') }
    end
  end
end

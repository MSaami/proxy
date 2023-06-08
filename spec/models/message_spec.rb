require 'rails_helper'

RSpec.describe Message, type: :model do
  include ActiveJob::TestHelper

  describe 'validations' do
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

    it {should validate_presence_of(:file)}
    it { is_expected.to validate_attached_of(:file) }
    it { is_expected.to validate_content_type_of(:file)
      .allowing('text/csv', 'image/png', 'application/pdf', 'image/jpeg') }
  end

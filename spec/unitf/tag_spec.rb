# frozen_string_literal: true

RSpec.describe Unitf::Tag do
  it 'has a version number' do
    expect(Unitf::Tag::VERSION).not_to be nil
  end
end

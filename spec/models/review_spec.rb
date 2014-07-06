require 'spec_helper'

describe Review do
  it { should belong_to :video }
  it { should belong_to :author }
  it { should validate_presence_of :body }
  it { should validate_presence_of :rating }
  it { should validate_presence_of :author }
  it { should ensure_inclusion_of(:rating).in_range(1..5) }
  it { should allow_value(Time.now).for(:created_at) }
  it { should allow_value(Time.now).for(:updated_at) }
end
require 'rails_helper'

RSpec.describe Beer, type: :model do
  let(:beer) do
    FactoryGirl.create(
      :beer,
      brewery: "Hoyne",
      name: "Devil's Dream",
      style: "IPA"
    )
  end

  it { is_expected.to have_many :ballots }

  it "is invalid without a name" do
    expect(described_class.new.valid?).to be false
  end

  it "is valid with a name at least three characters long" do
    expect(described_class.new(name: "Hop Circle IPA").valid?).to be true
  end

  it "is invalid with a name less than three characters long" do
    expect(described_class.new(name: "No").valid?).to be false
  end

  describe "#display_name" do
    subject { beer.display_name }

    it "nicely formats the beer for display to the front-end" do
      expect(subject).to eq "Hoyne Devil's Dream IPA"
    end
  end
end

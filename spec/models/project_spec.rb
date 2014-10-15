require 'rails_helper'

describe Project do

  describe "next" do
    before do
      @first  = create(:project)
      @second = create(:project)
      @third  = create(:project)
    end

    it "returns the next project (sorted by id)" do
      expect(@first.next).to eq(@second)
      expect(@second.next).to eq(@third)
    end

    it "sorts by episode" do
      create(:episode).active = true
      episode = create(:episode)
      @first.episodes << episode
      @third.episodes << episode

      expect(@first.next(episode)).to eq(@third)
    end
  end

  describe "previous" do
    before do
      @first  = create(:project)
      @second = create(:project)
      @third  = create(:project)
    end

    it "returns the previous project (sorted by id)" do
      expect(@second.previous).to eq(@first)
      expect(@third.previous).to eq(@second)
    end

    it "sorts by episodes" do
      create(:episode).active = true
      episode = create(:episode)
      @first.episodes << episode
      @third.episodes << episode

      expect(@third.previous(episode)).to eq(@first)
    end
  end
end

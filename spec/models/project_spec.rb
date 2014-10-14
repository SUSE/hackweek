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
  end
end

require 'rails_helper'

describe Project do

  describe "by_episode scope" do
    before do
      3.times { create(:project) }
      create(:project_with_episode)
    end

    it "returns all projects if episode is 'nil'" do
      expect(Project.by_episode(nil)).to eq(Project.all)
    end

    context "when called with episode parameter" do
      before do
        @episode = create(:episode)
        2.times {
          project = create(:project)
          project.episodes << @episode
        }
      end

      it "returns all projects of that episode" do
        expect(Project.by_episode(@episode)).to eq(
          Project.joins(:episodes).where(:episodes => { :id => @episode.id })
        )
      end
    end
  end

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
  
  describe 'active?' do
    it "returns true for ideas" do
      expect(FactoryGirl.create(:idea).active?).to eq(true)
    end

    it "it returns true for projects" do
      expect(FactoryGirl.create(:project).active?).to eq(true)
    end

    it "returns false for anything that is not an idea or project" do
      expect(FactoryGirl.create(:invention).active?).to eq(false)
      expect(FactoryGirl.create(:record).active?).to eq(false)
    end
  end

  describe "join!" do
    before do
      @project = FactoryGirl.create(:project)
      @idea = FactoryGirl.create(:idea)
      @user = FactoryGirl.create(:user)
      @project.join!(@user)
      @idea.join!(@user)
    end

    it "converts a project state from 'idea' to 'project' " do
      expect(@idea.project?).to eq(true)
    end

    it "adds a user to the project" do
      expect(@project.users).to include(@user)
    end

    it "creates an Update object assigned to the user" do
      expect(@project.updates.last.author).to eq(@user)
    end

    context "when project has no users (state == idea)" do
      it { expect(@idea.updates.last.text).to eq("started") }
    end

    context "when project has a user (state == project)" do
      it { expect(@project.updates.last.text).to eq("joined") }
    end
  end

  describe "leave!" do
    before do
      @project = FactoryGirl.create(:project)
      @user = @project.users.first
      @project.leave!(@user)
    end

    it "removes a user from the project" do
      expect(@project.users).not_to include(@user)
    end

    it "creates an Update for the user with text 'left'" do
      expect(@project.updates.last.author).to eq(@user)
      expect(@project.updates.last.text).to eq("left")
    end

    context "when the removed user was the last one" do
      it { expect(@project.idea?).to eq(true) }
    end
  end
end

require 'rails_helper'

describe Project do
  describe 'next' do
    before do
      @first  = create(:project)
      @second = create(:project)
      @third  = create(:project)
    end

    it 'returns the next project (sorted by id)' do
      expect(@first.next).to eq(@second)
      expect(@second.next).to eq(@third)
    end

    it 'sorts by episode' do
      create(:episode).active = true
      episode = create(:episode)
      @first.episodes << episode
      @third.episodes << episode

      expect(@first.next(episode)).to eq(@third)
    end
  end

  describe 'previous' do
    before do
      @first  = create(:project)
      @second = create(:project)
      @third  = create(:project)
    end

    it 'returns the previous project (sorted by id)' do
      expect(@second.previous).to eq(@first)
      expect(@third.previous).to eq(@second)
    end

    it 'sorts by episodes' do
      create(:episode).active = true
      episode = create(:episode)
      @first.episodes << episode
      @third.episodes << episode

      expect(@third.previous(episode)).to eq(@first)
    end
  end

  describe 'active?' do
    it 'returns true for ideas' do
      expect(FactoryBot.create(:idea).active?).to eq(true)
    end

    it 'it returns true for projects' do
      expect(FactoryBot.create(:project).active?).to eq(true)
    end

    it 'returns false for anything that is not an idea or project' do
      expect(FactoryBot.create(:invention).active?).to eq(false)
      expect(FactoryBot.create(:record).active?).to eq(false)
    end
  end

  describe 'join!' do
    before do
      @project = FactoryBot.create(:project)
      @idea = FactoryBot.create(:idea)
      # We sort updates by updated_at, make sure it's different from the creation updates
      sleep 1
      @user = FactoryBot.create(:user)
      @project.join!(@user)
      @idea.join!(@user)
    end

    it 'converts a project state from "idea" to "project"' do
      expect(@idea.project?).to eq(true)
    end

    it 'adds a user to the project' do
      expect(@project.users).to include(@user)
    end

    it 'creates an Update object assigned to the user' do
      expect(@project.updates.first.author).to eq(@user)
    end

    context 'when project has no users (state == idea)' do
      it { expect(@idea.updates.first.text).to eq('started') }
    end

    context 'when project has a user (state == project)' do
      it { expect(@project.updates.first.text).to eq('joined') }
    end
  end

  describe 'leave!' do
    before do
      @project = FactoryBot.create(:project)
      # We sort updates by updated_at, make sure it's different from the creation updates
      sleep 1
      @user = @project.users.first
      @project.leave!(@user)
    end

    it 'removes a user from the project' do
      expect(@project.users).not_to include(@user)
    end

    it 'creates an Update for the user with text "left"' do
      expect(@project.updates.first.author).to eq(@user)
      expect(@project.updates.first.text).to eq('left')
    end

    context 'when the removed user was the last one' do
      it { expect(@project.idea?).to eq(true) }
    end
  end

  describe 'destroy', :search do
    it 'deletes associated comments' do
      project = create :project, :with_comments
      project.destroy!
      expect(Comment.count).to be 0
    end
  end

  describe 'similar_projects' do
    let(:project) { create(:project) }
    let(:project2) { create(:project) }
    let(:user) { create(:user) }

    before do
      project.add_keyword! 'web', user
      project2.add_keyword! 'web', user
    end

    it 'gives an empty array when there is no common keyword' do
      project2.remove_keyword!('web', user)
      expect(project.similar_projects_keywords).to eq([])
    end

    it 'provides array of common keywords in projects' do
      expect(project.similar_projects_keywords).to include(Keyword.find_by_name('web'))
    end
  end

  describe '.joined?' do
    let(:project) { create(:project) }
    let(:user) { create(:user) }
    let(:user2) { create(:user) }

    it 'returns true if user is there' do
      project.users = [user]
      expect(project.joined?(user)).to eq(true)
    end

    it 'returns false if user the project has no users' do
      project.users = []
      expect(project.joined?(user)).to eq(false)
    end

    it 'returns false if user is not there' do
      project.users = [user2]
      expect(project.joined?(user)).to eq(false)
    end
  end

  describe 'send_notification' do
    let(:user) { create :user }
    let(:user2) { create :user }
    let(:project) { create :project }

    it 'send notification to project_followers' do
      project.project_followers << user
      project.send_notification user2, 'msg'
      expect(Notification.where(recipient: user).count).to eq(1)
    end
  end

  describe 'emoji support' do
    it 'saves and retrieves project descriptions with emoji characters' do
      emoji_description = 'Project with emojis 😱🎉👍 and more text'
      project = create(:project, description: emoji_description)
      project.reload
      expect(project.description).to eq(emoji_description)
    end

    it 'saves and retrieves project titles with emoji characters' do
      emoji_title = 'My Awesome Project 🚀'
      project = create(:project, title: emoji_title)
      project.reload
      expect(project.title).to eq(emoji_title)
    end
  end
end

require 'rails_helper'

describe Episode do
  describe 'active' do
    it 'returns the active episode' do
      3.times { FactoryGirl.create(:episode) }
      active_episode = FactoryGirl.create(:active_episode)
      expect(Episode.active).to eq(active_episode)
      active_episode.delete
      expect(Episode.active).to eq(nil)
    end
  end

  describe 'active=' do
    it 'activates the episode' do
      episode = FactoryGirl.create(:episode)
      episode.active = true
      expect(Episode.active).to eq(episode)
    end

    it 'deactivates all other episodes' do
      activated_episodes = [
        FactoryGirl.create(:episode),
        FactoryGirl.create(:episode)
      ]
      activated_episodes.each { |e| e.update_attributes!(active: true) }

      episode = FactoryGirl.create(:episode)
      episode.active = true
      activated_episodes.each do |e|
        expect(e.reload.active).to eq(false)
      end
    end
  end
end

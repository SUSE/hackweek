require 'rails_helper'
require 'cancan/matchers'

describe 'Ability' do
  subject(:ability) { Ability.new(user) }
  let(:user) { nil }

  context 'when user is a normal user' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:own_project) { create(:project, originator: user) }
    let(:foreign_project) { create(:project, originator: other_user) }
    let(:own_comment) { create(:comment, commenter: user) }
    let(:foreign_comment) { create(:comment, commenter: other_user) }
    let(:collaborated_project) { create(:project, originator: other_user, users: [user]) }

    # Myself
    it { is_expected.not_to be_able_to(:create, user) }
    it { is_expected.to be_able_to(:update, user) }
    it { is_expected.not_to be_able_to(:destroy, user) }
    it { is_expected.to be_able_to(:add_keyword, user) }
    it { is_expected.to be_able_to(:delete_keyword, user) }

    # Others
    it { is_expected.not_to be_able_to(:create, other_user) }
    it { is_expected.not_to be_able_to(:update, other_user) }
    it { is_expected.not_to be_able_to(:destroy, other_user) }
    it { is_expected.not_to be_able_to(:add_keyword, other_user) }
    it { is_expected.not_to be_able_to(:delete_keyword, other_user) }

    it { is_expected.to be_able_to(:manage, own_project) }
    it { is_expected.not_to be_able_to(:manage, foreign_project) }

    it { is_expected.to be_able_to(:create, own_comment) }
    it { is_expected.to be_able_to(:update, own_comment) }
    it { is_expected.not_to be_able_to(:destroy, own_comment) }

    it { is_expected.not_to be_able_to(:create, foreign_comment) }
    it { is_expected.not_to be_able_to(:update, foreign_comment) }
    it { is_expected.not_to be_able_to(:destroy, foreign_comment) }

    %i[edit update add_keyword delete_keyword advance recess add_episode delete_episode].each do |action|
      it { is_expected.to be_able_to(action, collaborated_project) }
    end

    it { is_expected.not_to be_able_to(:destroy, collaborated_project) }

    it { is_expected.not_to be_able_to(:manage, Announcement.new) }
    it { is_expected.not_to be_able_to(:manage, Faq.new) }
  end

  context 'when user is an organizer' do
    let(:user) { create(:organizer) }

    it { is_expected.to be_able_to(:manage, Announcement.new) }
    it { is_expected.to be_able_to(:manage, Faq.new) }
  end
end

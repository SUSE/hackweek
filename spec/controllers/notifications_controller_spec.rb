require 'rails_helper'

describe NotificationsController do
  let(:notification) {create :notification}

  before :each do
    sign_in create :user
  end

  describe 'GET index' do
    it 'assigns all notification as @notifications' do
      get :index, {}

      expect(assigns(:older_notifications)).to eq([notification])
    end
  end

  describe 'POST mark_as_read' do
    it 'makes all the unread msges as read' do
      notification = create :notification
      expect{
        post :mark_as_read, format: :js
      }.to change(Notification.unread, :count).by(-1)
    end
  end
end

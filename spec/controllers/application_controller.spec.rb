require 'rails_helper'

RSpec.describe ApplicationController do
  controller do
    def index
      render plain: 'anonymous controller'
    end
  end
  describe '#safe_markdown' do
    it 'renders simple tags' do
      source = '**bold**'
      expect(subject.safe_markdown(source)).to eq "<p><strong>bold</strong></p>\n"
    end
    it 'escapes html' do
      source = 'Hello<script>alert("Hello! I am an alert box!!");</script> World'
      expect(subject.safe_markdown(source)).to eq "<p>Hello World</p>\n"
    end
  end
end

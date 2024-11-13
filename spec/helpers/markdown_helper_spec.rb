require 'rails_helper'

RSpec.describe MarkdownHelper, type: :helper do
  describe '.enrich_markdown' do
    it 'translates emoji' do
      text = 'I need :coffee: so badly, working openSUSE:Factory:Staging:F'
      expect(enrich_markdown(markdown: text)).to eq('I need ![add-emoji](https://github.githubassets.com/images/icons/emoji/coffee.png) so badly, working openSUSE:Factory:Staging:F')
    end

    it 'translate @user links' do
      text = 'Hey @hans, how are you?'
      expect(enrich_markdown(markdown: text)).to eq('Hey [@hans](/users/hans), how are you?')
    end

    it 'translates hw#slug links' do
      text = 'Have you seen hw#super-cool? Its awesome'
      expect(enrich_markdown(markdown: text)).to eq('Have you seen [hw#super-cool](/projects/super-cool)? Its awesome')
    end
  end
end

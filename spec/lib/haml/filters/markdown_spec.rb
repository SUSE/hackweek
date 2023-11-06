require 'rails_helper'

describe Haml::Filters::Markdown do
  describe '#render' do
    it_behaves_like 'a markdown renderer'
  end
end

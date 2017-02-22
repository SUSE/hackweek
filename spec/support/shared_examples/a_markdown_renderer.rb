RSpec.shared_examples "a markdown renderer" do
  it 'correctly renders simple tags' do
    source = '**bold**'
    expect(subject.render(source)).to eq "<p><strong>bold</strong></p>\n"
  end

  it 'escapes HTML tags' do
    source = '<img src=1 onerror=alert(&#34;pwned&#34;)>'
    escaped_source = "<p>&lt;img src=1 onerror=alert(&amp;#34;pwned&amp;#34;)&gt;</p>\n"
    expect(subject.render(source)).to eq escaped_source
  end

  it 'supports @user links' do
    source = 'Hey @hans, how are you?'
    escaped_source = "<p>Hey <a href=\"/users/hans\">@hans</a>, how are you?</p>\n"
    expect(subject.render(source)).to eq escaped_source
  end

  it 'supports hw#slug links' do
    source = 'Have you seen hw#super-cool? Its awesome'
    escaped_source = "<p>Have you seen <a href=\"/projects/super-cool\">hw#super-cool</a>? Its awesome</p>\n"
    expect(subject.render(source)).to eq escaped_source
  end
end

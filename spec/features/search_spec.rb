require 'rails_helper'

describe 'Search result', search: true do
  it 'can be found by the exact string' do
    project = create(:project, title: 'Black')
    project2 = create(:project, title: 'White')

    # Honestly, manual indexing shouldn't be necessary.
    # But it seems that everything happens a little bit too fast for deltas to pick up,
    # so let's reindex everything manually. Just to be sure.
    index

    results = Project.search project.title
    expect(results).to contain_exactly(project)
  end

  it 'can be found by string with a different case' do
    project = create(:project, title: 'Black')
    index
    results = Project.search 'bLacK'
    expect(results).to contain_exactly(project)
  end

  it 'can be found by substring' do
    project = create(:project, title: 'Supercalifragilisticexpialidocious')
    index
    results = Project.search 'ilistic'
    expect(results).to contain_exactly(project)
  end

  it 'can be found by stemming' do
    # stemming means that different forms of the verb are treated the as the same word.
    # For example, reading and read are considered the same word.
    project = create(:project, title: 'Read')
    index
    results = Project.search 'reading'
    expect(results).to contain_exactly(project)
  end

  it 'can be found using operators' do
    # stemming means that different forms of the verb are treated the as the same word.
    # For example, reading and read are considered the same word.
    linux = create(:project, title: 'Linux')
    opensuse = create(:project, title: 'openSUSE', description: 'A Linux distribution')
    hurd = create(:project, title: 'Hurd', description: 'A kernel replacing Linux')
    index

    results = Project.search 'linux'
    expect(results.length).to eq(3)

    results = Project.search 'linux -openSUSE -Hurd'
    expect(results).to contain_exactly(linux)

    results = Project.search 'linux NOT openSUSE'
    expect(results).to contain_exactly(linux, hurd)
  end
end

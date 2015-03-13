require 'rails_helper'

describe 'Search result', search: true do
  it 'can be found by the exact string' do
    project = create(:project, title: 'Black')
    project2 = create(:project, title: 'White')
    Sunspot.commit
    search = Project.search { fulltext "#{project.title}"}
    expect(search.results).to include(project)
    expect(search.results).not_to include(project2)
  end

  it 'can be found by string with a different case' do
    project = create(:project, title: 'Black')
    Sunspot.commit
    search = Project.search { fulltext 'bLacK'}
    expect(search.results.first).to eq(project)
  end

  it 'can be found by substring' do
    project = create(:project, title: 'Supercalifragilisticexpialidocious')
    Sunspot.commit
    search = Project.search { fulltext 'ilistic'}
    expect(search.results.first).to eq(project)
  end

  it 'can be found by substring' do
    project = create(:project, title: 'Supercalifragilisticexpialidocious')
    Sunspot.commit
    search = Project.search { fulltext 'ilistic'}
    expect(search.results.first).to eq(project)
  end

  it 'can be found by stemming' do
    # stemming means that different forms of the verb are treated the as the same word.
    # For example, reading and read are considered the same word.
    project = create(:project, title: 'Read')
    Sunspot.commit
    search = Project.search { fulltext 'reading'}
    expect(search.results.first).to eq(project)
  end

  it 'can be found using operators' do
    # stemming means that different forms of the verb are treated the as the same word.
    # For example, reading and read are considered the same word.
    linux = create(:project, title: 'Linux')
    opensuse = create(:project, title: 'openSUSE', description: 'A Linux distribution')
    hurd = create(:project, title: 'Hurd', description: 'A kernel replacing Linux')
    Sunspot.commit

    search = Project.search { fulltext 'linux'}
    expect(search.total).to eq(3)

    search = Project.search { fulltext 'linux -openSUSE -Hurd' }
    expect(search.total).to eq(1)
    expect(search.results.first).to eq(linux)
    expect(search.results).not_to include(opensuse)
    expect(search.results).not_to include(hurd)

    search = Project.search { fulltext 'linux NOT openSUSE' }
    expect(search.total).to eq(2)
    expect(search.results).to include(linux)
    expect(search.results).to include(hurd)
  end
end

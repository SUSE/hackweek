require 'rails_helper'

describe 'Search result', search: true do
  let!(:project) { create :project, title: 'SuperFragility' }
  let!(:other_project) { create :project }

  it 'can be found by the exact string' do
    results = Project.search project.title
    expect(results).to contain_exactly(project)
  end

  it 'can be found by string with a different case' do
    results = Project.search project.title.swapcase
    expect(results).to contain_exactly(project)
  end

  # OK, I give up. Wildcards seem not to work in test mode (but works perfectly in development). 
  # Test this manually, please
  it 'can be found by substring in wildcard-enabled mode' do
    results = Project.search 'fragil', star: true
    expect(results).to contain_exactly(project)
  end

  # Stemming depends on the morphology engines bundled with sphinx. Current testing setup is
  # kinda weird here — skipping this test for now
  it 'can be found by stemming' do
    # stemming means that different forms of the verb are treated the as the same word.
    # For example, reading and read are considered the same word.
    project = create(:project, title: 'Read')
    results = Project.search 'reading'
    expect(results).to contain_exactly(project)
  end

  # TODO Add tooltip with search operators to the corresponding view
  it 'can be found using operators' do
    linux = create(:project, title: 'Linux')
    opensuse = create(:project, title: 'openSUSE', description: 'A Linux distribution with cool kernel')
    hurd = create(:project, title: 'Hurd', description: 'A kernel replacing Linux')

    results = Project.search 'linux'
    expect(results).to contain_exactly(linux, opensuse, hurd)

    results = Project.search 'hurd|opensuse'
    expect(results).to contain_exactly(hurd, opensuse)

    results = Project.search 'linux -openSUSE'
    expect(results).to contain_exactly(linux, hurd)

    results = Project.search 'linux << kernel'
    expect(results).to contain_exactly(opensuse)
  end
end

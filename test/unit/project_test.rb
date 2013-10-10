require 'test_helper'

class ProjectTest < ActiveSupport::TestCase

  setup do
    Sunspot.commit
    Project.reindex
  end

  test "create" do
    user = users(:linus)
    
    title = "My Title"
    
    project = Project.create!( :title => title, :originator => user, :description => "text" )
    
    assert_equal title, project.title
    assert_equal user, project.originator
    
    assert_equal 1, project.updates.count
    assert_equal user, project.updates.last.author
    assert_match /originated/, project.updates.last.text
  end
  
  test "user joins project" do
    user = users(:linus)
    project = projects(:git)

    assert_equal 0, project.users.count

    project.join! user
    
    assert_equal 1, project.users.count
    assert_equal user, project.users.last

    assert_equal 1, project.updates.count
    assert_equal user, project.updates.last.author
    assert_match /started/, project.updates.last.text
  end

  test "user leaves project" do
    user = users(:linus)
    project = projects(:git)

    project.join! user
    
    assert_equal 1, project.users.count
    
    project.leave! user

    assert_equal 0, project.users.count

    assert_equal 2, project.updates.count
    assert_equal user, project.updates.last.author
    assert_match /left/, project.updates.last.text
  end

  test "project can be found by the exact title" do
    project = projects(:openSUSE)
    result = Project.search { fulltext "openSUSE" }
    assert_equal 1, result.results.length
    assert_equal [project], result.results
  end

  test "project can be found by title with different case (up/down)" do
    project = projects(:openSUSE)
    result = Project.search { fulltext "OpeNsUsE" }
    assert_equal 1, result.results.length
    assert_equal [project], result.results
  end

  test "project can be found by a substring of the title" do
    project = projects(:openSUSE)
    result = Project.search { fulltext "opensu" }
    assert_equal 1, result.results.length
    assert_equal [project], result.results
  end

  test "project can be found by description" do
    project = projects(:openSUSE)
    result = Project.search { fulltext "friendly neigh" }
    assert_equal 1, result.results.length
    assert_equal [project], result.results
  end

  test "project can be found by stemming" do
    # stemming means that different forms of the verb are treated the as the same word. For example, reading and read are considered the same word. More info at http://wiki.apache.org/solr/AnalyzersTokenizersTokenFilters
    # in our fixture, openSUSE project has the "promoting" word
    project = projects(:openSUSE)
    result = Project.search { fulltext "promotes" }
    assert_equal 1, result.results.length
    assert_equal [project], result.results
    result = Project.search { fulltext "promoting" }
    assert_equal 1, result.results.length
    assert_equal [project], result.results
  end
  
  test "project can be found using operators" do
    project_l = projects(:linux)
    project_o = projects(:openSUSE)
    project_h = projects(:hurd)
    result = Project.search { fulltext "linux" }
    assert_equal 3, result.results.length
    assert result.results.include? project_l
    assert result.results.include? project_o
    assert result.results.include? project_h
    result = Project.search { fulltext "linux -openSUSE -Hurd" }
    assert_equal 1, result.results.length
    assert_equal [project_l], result.results
    result = Project.search { fulltext "linux NOT openSUSE" }
    assert_equal 2, result.results.length
    assert result.results.include? project_l
    assert result.results.include? project_h
  end
end

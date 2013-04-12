require 'test_helper'

class ProjectImporterTest < ActiveSupport::TestCase

  test "get import user" do
    assert_difference "User.count" do
      user = ProjectImporter.get_import_user
      assert_equal "Project Importer", user.name
    end
  end
  
  test "import projects" do
    
    json = <<EOT
{
  "projects": [
    {
      "title": "GitCool",
      "description": "Here will be a description."
    },
    {
      "title": "Github-Pages-Jekyll-Templates",
      "description": "Here will be a description."
    },
    {
      "title": "Dashoid",
      "description": "Here will be a description."
    }
  ]
}
EOT
    
    ProjectImporter.import json
    
    assert_equal 5, Project.count
    assert_equal "Dashoid", Project.last.title
    assert_equal ProjectImporter.get_import_user, Project.last.originator
  end

  test "don't duplicate entries" do

    assert_difference "Project.count", +3 do
      json = <<EOT
{
  "projects": [
    {
      "title": "GitCool",
      "description": "Here will be a description."
    },
    {
      "title": "Github-Pages-Jekyll-Templates",
      "description": "Here will be a description."
    },
    {
      "title": "Dashoid",
      "description": "Here will be a description."
    }
  ]
}
EOT
    
      ProjectImporter.import json
    end

    assert_difference "Project.count", 0 do
      json = <<EOT
{
  "projects": [
    {
      "title": "Dashoid",
      "description": "Here will be a description."
    }
  ]
}
EOT
    
      ProjectImporter.import json
    end

    assert_difference "Project.count", 1 do
      json = <<EOT
{
  "projects": [
    {
      "title": "Dashoid2",
      "description": "Here will be a description."
    }
  ]
}
EOT
    
      ProjectImporter.import json
    end
  end

  test "import users" do

    json = <<EOT
{
  "people": [
    {
      "name": "Adam Spiers"
    },
    {
      "name": "Adrian Schroeter"
    },
    {
      "name": "Al Cho"
    },
    {
      "name": "Alexander Bergmann"
    }
  ]
}
EOT
    
    assert_difference "User.count", +4 do
      ProjectImporter.import json
  
      assert_equal "Alexander Bergmann", User.last.name
    end
  end
  
  test "import project with users" do

    json = <<EOT
{
  "projects": [
    {
      "title": "Kill-YCP-by-Mechanical-Translation",
      "categories": [
        "yast"
      ],
      "tags": [
        "yast",
        "ycp",
        "ruby",
        "transpiler",
        "inprogress",
        "helpwanted"
      ],
      "description": "Our famous [YaST]",
      "originator": "David Majda",
      "members": [
        "David Majda",
        "Josef Reidinger",
        "Martin Vidner",
        "Ladislav Slezak"
      ]
    }
  ],
  "people": [
    {
      "name": "David Majda"
    },
    {
      "name": "Josef Reidinger"
    },
    {
      "name": "Martin Vidner"
    },
    {
      "name": "Ladislav Slezak"
    }
  ]
}
EOT

    assert_difference "User.count", +4 do
      ProjectImporter.import json
    end

    dmajda = User.find_by_name "David Majda"
    assert_not_nil dmajda
    
    project = Project.last
    assert_equal project.title, "Kill-YCP-by-Mechanical-Translation"
    assert_equal dmajda, project.originator
    assert_equal 4, project.users.count

  end

  test "import keywords" do

    json = <<EOT
{
  "projects": [
    {
      "title": "Kill-YCP-by-Mechanical-Translation",
      "categories": [
        "yast"
      ],
      "tags": [
        "yast",
        "ycp",
        "ruby",
        "transpiler",
        "InProgress",
        "helpwanted"
      ],
      "description": "Our famous [YaST]",
      "originator": "David Majda",
      "members": [
        "David Majda",
        "Josef Reidinger",
        "Martin Vidner",
        "Ladislav Slezak"
      ]
    }
  ],
  "people": [
    {
      "name": "David Majda"
    },
    {
      "name": "Josef Reidinger"
    },
    {
      "name": "Martin Vidner"
    },
    {
      "name": "Ladislav Slezak"
    }
  ]
}
EOT

    assert_difference "Keyword.count", +6 do
      ProjectImporter.import json
    end

    project = Project.last

    assert_equal 6, project.keywords.count
    assert_not_nil project.keywords.include? "yast"
    assert_not_nil project.keywords.include? "inprogress"
  end
  
end

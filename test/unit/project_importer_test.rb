require 'test_helper'

class ProjectImporterTest < ActiveSupport::TestCase

  test "get import user" do
    assert_difference "User.count" do
      user = ProjectImporter.get_import_user
      assert_equal "Project Importer", user.name
    end
  end
  
  test "import" do
    
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

end

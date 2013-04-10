class ProjectImporter

  def self.import json
    import_user = get_import_user
    
    data = JSON.parse json
    data["projects"].each do |p|
      project = Project.find_by_title p["title"]
      if !project
        project = Project.new
        project.originator = import_user
      end
      project.title = p["title"]
      project.description = p["description"]
      project.save!
    end
  end
  
  def self.get_import_user
    user_name = "Project Importer"
    user = User.find_by_name "Project Importer"
    if ( !user )
      user = User.create! :name => user_name
    end
    user
  end

end

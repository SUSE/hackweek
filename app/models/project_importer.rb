class ProjectImporter

  def self.find_or_create_user name
    user = User.find_by_name name
    if !user
      user = User.create :name => name
    end
    user
  end
  
  def self.import json
    data = JSON.parse json
    
    if data["people"]
      data["people"].each do |u|
        user = User.find_by_name u["name"]
        if !user
          user = User.new
        end
        user.name = u["name"]
        user.save!
      end
    end
    
    if data["projects"]
      data["projects"].each do |p|
        project = Project.find_by_title p["title"]
        if !project
          project = Project.new
        end

        originator = p["originator"]
        if !originator
          project.originator = get_import_user
        else
          project.originator = find_or_create_user originator
        end
        if p["members"]
          p["members"].each do |member|
            project.users.push find_or_create_user( member )
          end
        end

        project.title = p["title"]
        project.description = p["description"]
        project.save!
      end
    end
  end
  
  def self.get_import_user
    user_name = "Project Importer"
    user = User.find_by_name "Project Importer"
    if ( !user )
      user = User.create! :name => user_name, :email => "pi@example.com", :uid => "project_importer"
    end
    user
  end

end

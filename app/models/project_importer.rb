class ProjectImporter

  def self.find_or_create_user name
    user = User.find_by_name name
    if !user
      user = User.create :name => name
    end
    user
  end
  
  def self.add_keyword project, name
    name.downcase!
    keyword = Keyword.find_by_name name
    if !keyword
      keyword = Keyword.create! :name => name
    end
    if !project.keywords.include? keyword
      project.keywords << keyword
    end
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
        user.email = u["email"]
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

        if p["categories"]
          p["categories"].each do |category|
            add_keyword project, category
          end
        end
        if p["tags"]
          p["tags"].each do |tag|
            add_keyword project, tag
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

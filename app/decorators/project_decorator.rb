class ProjectDecorator < Draper::Decorator
  delegate_all

  def state_name
    if ["idea", "invention"].include?(object.aasm_state)
      "an #{object.aasm_state}"
    else
      "a #{object.aasm_state}"
    end
  end

  def updated_at
    "Last updated #{h.time_ago_in_words(object.updated_at)} ago."
  end

  def kudos
    if object.kudos.length > 0
      "Captured #{h.pluralize(object.kudos.length, "hackers heart.", "hacker hearts.")}"
    else
      "No love."
    end
  end

  def grab_it_link
    if object.users.empty?
      "No hacker. How about you #{h.link_to('grab it!', h.join_project_path(object), :method => :post)}".html_safe
    end
  end

  def like_button
    dislike = "display: none;" unless object.kudos.include?(h.current_user)
    like    = "display: none;" if object.kudos.include?(h.current_user)

    dislike_opts = {:title=>'Dislike this project?', :class=> "btn btn-default btn-xs", :id => "dislike-#{object.id}", :style => "#{dislike}", :remote=>true}
    like_opts    = {:title=>'Like this project', :class=> "btn btn-default btn-xs", :id => "like-#{object.id}", :style => "#{like}", :remote => true}

    h.link_to(h.dislike_project_path(object), dislike_opts) { h.content_tag(:i, "", :class => 'fa fa-heart', :style =>  "color: #73ba25;") }.html_safe +
    h.link_to(h.like_project_path(object), like_opts) { h.content_tag(:i, "", :class => 'fa fa-heart-o') }.html_safe
  end
end

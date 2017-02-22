module Haml::Filters
  remove_filter("Markdown") #remove the existing Markdown filter

  module Markdown
    include Haml::Filters::Base

    def render(text)
      # replace @user with a link to user
      text.gsub!(/([^\w]|^)@([-\w]+)([^\w]|$)/) {"#{Regexp.last_match(1)}[@#{Regexp.last_match(2)}](#{Rails.application.routes.url_helpers(only_path: true).user_path(Regexp.last_match(2))})#{Regexp.last_match(3)}" }
      # replace hw#slug with a link to project
      text.gsub!(/([^\w]|^)hw#([-\w]+)([^\w]|$)/) {"#{Regexp.last_match(1)}[hw##{Regexp.last_match(2)}](#{Rails.application.routes.url_helpers(only_path: true).project_path(Regexp.last_match(2))})#{Regexp.last_match(3)}" }

      Redcarpet::Markdown.new(
        Redcarpet::Render::HTML.new(escape_html: true)
      ).render(text)
    end
  end
end

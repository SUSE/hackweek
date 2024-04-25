require 'redcarpet'
require 'rouge/plugins/redcarpet'

module Haml
  class Filters
    class Markdown < Base
      # remove_filter('Markdown') # remove the existing Markdown filter

      class RougeRender < ::Redcarpet::Render::HTML
        include Rouge::Plugins::Redcarpet
      end

      def render(text)
        # replace @user with a link to user
        text.gsub!(/([^\w]|^)@([-\w]+)([^\w]|$)/) do
          "#{Regexp.last_match(1)}[@#{Regexp.last_match(2)}](#{::Rails.application.routes.url_helpers(only_path: true).user_path(Regexp.last_match(2))})#{Regexp.last_match(3)}"
        end
        # replace hw#slug with a link to project
        text.gsub!(/([^\w]|^)hw#([-\w]+)([^\w]|$)/) do
          "#{Regexp.last_match(1)}[hw##{Regexp.last_match(2)}](#{::Rails.application.routes.url_helpers(only_path: true).project_path(Regexp.last_match(2))})#{Regexp.last_match(3)}"
        end

        renderer_options = { escape_html: true,
                             safe_links_only: true }
        markdown_options = { fenced_code_blocks: true,
                             disable_indented_code_blocks: true,
                             autolink: true }
        Redcarpet::Markdown.new(RougeRender.new(renderer_options), markdown_options).render(text)
      end
    end
  end
end

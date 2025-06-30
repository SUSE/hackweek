module MarkdownHelper
  def enrich_markdown(markdown:, lines: nil)
    # build an excerpt
    markdown = markdown.lines[0..(lines - 1)].join if lines

    # replace :smiley: with a link to github.com emojis
    markdown.gsub!(/(?<=^|\s):([\w+-]+):(?=\s|$)/) do |match|
      %(![add-emoji](https://github.githubassets.com/images/icons/emoji/#{match.to_str.tr(':', '')}.png))
    end
    # replace @hans with a link to the user with the login hans
    markdown.gsub!(/([^\w]|^)@([-\w]+)([^\w]|$)/) do
      "#{Regexp.last_match(1)}[@#{Regexp.last_match(2)}](#{::Rails.application.routes.url_helpers(only_path: true).user_path(Regexp.last_match(2))})#{Regexp.last_match(3)}"
    end
    # replace hw#my-project with a link to the project with the slug my-project
    markdown.gsub!(/([^\w]|^)hw#([-\w]+)([^\w]|$)/) do
      "#{Regexp.last_match(1)}[hw##{Regexp.last_match(2)}](#{::Rails.application.routes.url_helpers(only_path: true).project_path(Regexp.last_match(2))})#{Regexp.last_match(3)}"
    end

    sanitize(markdown)
  end
end

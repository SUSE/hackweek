module Hackweek
  class MarkdownRenderer < Redcarpet::Render::HTML
    include Rails.application.routes.url_helpers(only_path: true)

    def preprocess(fulldoc)
      # @user links
      #fulldoc.gsub!(/([^\w]|^)@([-\w]+)([^\w]|$)/) \
      #             {"#{Regexp.last_match(1)}[@#{Regexp.last_match(2)}](#{user_path(Regexp.last_match(2))})#{Regexp.last_match(3)}" }
      # sanitize the HTML we get
      Sanitize.fragment(fulldoc, Sanitize::Config.merge(Sanitize::Config::RESTRICTED,
                                                        elements: Sanitize::Config::RESTRICTED[:elements] + ['pre'],
                                                        remove_contents: true
                                                       ))
    end
  end
end

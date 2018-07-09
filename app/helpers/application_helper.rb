module ApplicationHelper
  def bootstrap_class_for flash_type
    case flash_type
    when 'success'
      'alert-success'
    when 'error'
      'alert-danger'
    when 'alert'
      'alert-warning'
    when 'notice'
      'alert-info'
    else
      'alert-info'
    end
  end

  def active_page_size(page_size, param=nil)
    if param.blank?
      'active' if page_size.to_i == 10
    else
      'active' if page_size.to_i == param.to_i
    end
  end

  def emojify content
    content.to_str.gsub(/:([\w+-]+):/) do |match|
      %(![add-emoji](https://assets-cdn.github.com/images/icons/emoji/#{match.to_str.tr(':','')}.png))      
    end.html_safe if content.present?
  end
end

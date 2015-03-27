module ApplicationHelper
  def bootstrap_class_for flash_type
    case flash_type
    when 'success'
      'alert-success'
    when 'error'
      'alert-error'
    when 'alert'
      'alert-block'
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
end

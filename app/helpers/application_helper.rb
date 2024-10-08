module ApplicationHelper
  def bootstrap_class_for(flash_type)
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

  def active_page_size(page_size, param = nil)
    if param.blank?
      'active' if page_size.to_i == 10
    elsif page_size.to_i == param.to_i
      'active'
    end
  end
end

module ApplicationHelper

  def bootstrap_class_for flash_type
    case flash_type
      when 'success'
        "alert-success"
      when 'error'
        "alert-error"
      when 'alert'
        "alert-block"
      when 'notice'
        "alert-info"
      else
        flash_type.to_s
    end
  end

  def days_to_launch
    DateTime.new(2014,10,20).mjd - DateTime.now.mjd
  end

end

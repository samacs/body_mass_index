module ApplicationHelper
  def bootstrap_class_for(flash_type)
    case flash_type.to_s
    when 'success'
      'alert-success'
    when 'error'
      'alert-danger'
    when 'alert'
      'alert-warning'
    when 'notice'
      'alert-info'
    else
      flash_type.to_s
    end
  end

  def cp(*args)
    'active' if args.any? { |path| current_page?(path) }
  end
end

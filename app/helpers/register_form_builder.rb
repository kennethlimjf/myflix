class RegisterFormBuilder < ActionView::Helpers::FormBuilder

  def form_group_tag(method, &block)
    form_class = "form-group"
    
    errors = object.errors[method.to_sym]
    form_class += " has-error" if errors.any?

    @template.div_for(object, class: "#{form_class}", &block)
  end

  def error_tag(method)
    errors = object.errors[method.to_sym]
    "<span class=\"has-error\">#{errors.first}</span>".html_safe if errors.any?
  end

end
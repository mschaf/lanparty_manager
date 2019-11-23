class ActionView::Helpers::FormBuilder
  def error_messages_for(field_name)
    if self.object.errors[field_name].present?
      "<label class='form--error'>#{self.object.errors[field_name].join(', ')}</label>".html_safe
    end
  end
end
module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    content_tag(:div, messages, class: ["alert", "alert-error", "alert-danger"])
  end
end

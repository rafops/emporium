module DeviseHelper
  def devise_error_messages!
    return "" unless devise_error_messages?

    message = resource.errors.full_messages.first

    html = <<-HTML
    <div class="alert alert-danger" role="alert">#{message}</div>
    HTML

    html.html_safe
  end

  def devise_error_messages?
    !resource.errors.empty?
  end

end

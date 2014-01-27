module SessionsHelper
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  private
    def clear_return_to
      session.delete(:return_to)
    end

  # custom code
  def redirect_back
    redirect_to(session[:return_to])
    clear_return_to
  end

  def session_exist
    if session[:return_to]
      return true
    else
      return false
    end
  end

  def store_location_with_path(path)
    session[:return_to] = path
  end

  def redirect_via_token(token)
    @object = "#{token.redirect_class_name}".constantize.find(token.redirect_class_id)
    redirect_to @object
    # TODO: add extra params if any
  end
end
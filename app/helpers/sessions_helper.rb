module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    current_user = user
  end

  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= user_from_remeber_token
  end
  
  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil             # we could use just current_user and leave out "self."
  end

  def current_user?(user)
    user ==  self.current_user      # we could use just current_user and leave out "self."
  end

  def authenticate
  deny_access unless signed_in?
  end

  def deny_access
    store_location
    redirect_to signin_path,  :notice => "Please sign in to access this page."
    # The above line is equivalent to the following two lines.

    # flash[:notice] = "Please sign in to access this page."
    # redirect_to signin_path
  end
 
  def store_location
    session[:return_to_page] = request.fullpath  
  end
  
  def redirect_back_or_redirect_to(default_value)
    redirect_to(session[:return_to_page] || default_value)
    clear_return_to_page
  end
  
  def clear_return_to_page
    session[:return_to_page] = nil
  end
  
  private
  
  def user_from_remeber_token
    User.authenticate_with_salt(*remember_token)
  end
  
  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end
end

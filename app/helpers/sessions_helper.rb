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
    self.current_user = nil
  end

  def deny_access
    redirect_to signin_path,  :notice => "Please sign in to access this page."
  
    # The above line is equivalent to the following two lines.

    # flash[:notice] = "Please sign in to access this page."
    # redirect_to signin_path
  end
  
  private
  
  def user_from_remeber_token
    User.authenticate_with_salt(*remember_token)
  end
  
  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end
end

class SessionsController < ApplicationController

  def new
    @title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:email],
                                            params[:session][:password])

    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      render 'new'
    else
      # Handle success
      sign_in user
       redirect_back_or_redirect_to(user)  # redirect_to(user) Can be done this way too: redirect_to user_path(user)
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
end

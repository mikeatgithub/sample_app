class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @title  = @user.name
  end

  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def create
    # raise params[:user].inspect       # For debugging
    
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      # These two ways are equal
      # ------------------------------------------
      # flash[:success] = "Welcome to the Sample App!"
      # redirect_to @user
      # ------------------------------------------
      redirect_to @user, :flash => {:success => "Welcome to the Sample App!"}
      # ------------------------------------------
    else
      @title = 'Sign up'
      render 'new'
    end
  end
  
end

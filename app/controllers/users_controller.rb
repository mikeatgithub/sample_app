class UsersController < ApplicationController
  
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  #before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy

    def index
      @users = User.paginate(:page => params[:page])
      @title = "All users"
    end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
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
  
  def edit
    # raise request.inspect     # Stops the browser and lets you look at the contents of the request
    @user = User.find(params[:id])
    @title  = "Edit user"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      # It worked
      redirect_to @user, :flash => { :success => "Profile updated." }
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def destroy
    @user.destroy
    redirect_to users_path, :flash => { :success => "User destroyed." }
  end

  private
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
  
  def admin_user
    @user = User.find(params[:id])
    redirect_to(root_path) if (!current_user.admin? || current_user?(@user))
  end
end

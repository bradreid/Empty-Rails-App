class Admin::UsersController < AdminController
  
  def index
    @users = User.paginate(default_pagination_params)  
  end
  
  def new
    @user = User.new
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.update_attribute(:active, false)
    flash[:notice] = "You have successfully inactivated the user: #{@user.login}"
    redirect_to admin_users_path
  end
  
  def update
    @user = User.find(params[:id])
    if params[:user][:password].blank? 
      params[:user].delete(:password) 
      params[:user].delete(:password_confirmation) if params[:user][:password_confirmation].blank? 
    end 
    if @user.update_attributes(params[:user])
      flash[:notice] = "You successfully updated the user account"
      redirect_to admin_users_path
    else
      render 'edit'
    end
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "You successfully create a new user"
      redirect_to admin_users_path
    else
      render 'new'
    end
  end
end
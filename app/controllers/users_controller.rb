class UsersController < ApplicationController
  before_filter :authenticate_user!, :authenticate_user
  
  def show
  end


  private

    def authenticate_user
       if (@user = User.find(params[:id])) != current_user
         redirect_to user_path(current_user)
       end
    end
end

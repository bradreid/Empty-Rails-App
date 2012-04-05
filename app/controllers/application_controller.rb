class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :active_check!
  
private

  def default_pagination_params
    {:page => params[:page], :per_page => 20}
  end  
  
  def active_check!
    if current_user && !current_user.active?
      (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
      redirect_to root_path 
    end
  end
end

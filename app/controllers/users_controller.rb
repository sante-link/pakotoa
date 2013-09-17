class UsersController < ApplicationController
  load_and_authorize_resource :authority
  #load_and_authorize_resource :user, through: :authority
  authorize_resource :user

  add_breadcrumb "authorities.index.title", "authorities_path"
  add_breadcrumb :authority_title, "authority_path(@authority)"

  def index
    @users = User.all
  end

  def grant
    @user = User.find(params[:id])
    @authority.users << @user unless @authority.users.include?(@user)
  end

  def revoke
    @user = User.find(params[:id])
    @authority.users.delete(@user)
  end
end

class UsersController < ApplicationController
  load_and_authorize_resource :certificate_authority
  #load_and_authorize_resource :user, through: :certificate_authority
  authorize_resource :user

  add_breadcrumb "certificate_authorities.index.title", "certificate_authorities_path"
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

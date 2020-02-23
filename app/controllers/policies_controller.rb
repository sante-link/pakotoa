class PoliciesController < ApplicationController
  load_and_authorize_resource :policy

  #respond_to :html

  def index
    respond_with @policies
  end

  def new
    respond_with @policy
  end

  def create
    @policy.save
    respond_with @policy
  end

  def show
    redirect_to policy_subject_attributes_path(@policy)
  end

  def edit
    respond_with @policy
  end

  def update
    @policy.update_attributes(policy_params)
    respond_with @policy
  end

  def destroy
    @policy.destroy
    respond_with @policy
  end
private
  def policy_params
    params.require('policy').permit('name')
  end
end

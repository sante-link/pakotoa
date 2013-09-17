class SubjectAttributesController < ApplicationController
  respond_to :html

  load_and_authorize_resource :authority
  load_and_authorize_resource :subject_attribute, through: :authority

  add_breadcrumb "authorities.index.title", "authorities_path"
  add_breadcrumb :authority_title, "authority_path(@authority)"
  add_breadcrumb "subject_attributes.index.title", "authority_subject_attributes_path(@authority)", except: :index

  # GET /attributes
  def index
    @subject_attributes = @subject_attributes.order("position")
  end

  # GET /attributes/1
  def show
  end

  # GET /attributes/new
  def new
  end

  # GET /attributes/1/edit
  def edit
  end

  # POST /attributes
  def create
    @subject_attribute.save
    respond_with @authority, @subject_attribute
  end

  # PATCH/PUT /attributes/1
  def update
    @subject_attribute.update(subject_attribute_params)
    respond_with @authority, @subject_attribute
  end

  # DELETE /attributes/1
  def destroy
    @subject_attribute.destroy
    respond_with @authority, @subject_attribute
  end

  def sort
    params[:subject_attribute].each_with_index do |id, index|
      SubjectAttribute.update(id, position: index + 1)
    end
    render nothing: true
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def subject_attribute_params
      return params[:subject_attribute] if Array === params[:subject_attribute]
      params.require(:subject_attribute).permit(:oid_id, :default, :min, :max, :policy)
    end
end

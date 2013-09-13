class AuthoritiesController < ApplicationController
  respond_to :html

  load_and_authorize_resource :authority

  add_breadcrumb "authorities.index.title", "authorities_path", except: :index

  # GET /authorities
  # GET /authorities.json
  def index
    @authorities = @authorities.order("name ASC")
  end

  # GET /authorities/1
  # GET /authorities/1.json
  def show
  end

  # GET /authorities/new
  def new
  end

  # GET /authorities/1/edit
  def edit
  end

  # POST /authorities
  # POST /authorities.json
  def create
    @authority.save
    respond_with(@authority)
  end

  # PATCH/PUT /authorities/1
  # PATCH/PUT /authorities/1.json
  def update
    @authority.update(params[:authority])
    respond_with(@authority)
  end

  # DELETE /authorities/1
  # DELETE /authorities/1.json
  def destroy
    @authority.destroy
    respond_with(@authority)
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def authority_params
      params.require(:authority).permit(:name)
    end
end

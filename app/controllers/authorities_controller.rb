class AuthoritiesController < ApplicationController
  load_and_authorize_resource :authority

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
    @authority = Authority.new
  end

  # GET /authorities/1/edit
  def edit
  end

  # POST /authorities
  # POST /authorities.json
  def create
    @authority = Authority.new(authority_params)

    respond_to do |format|
      if @authority.save
        format.html { redirect_to @authority, notice: 'Authority was successfully created.' }
        format.json { render action: 'show', status: :created, location: @authority }
      else
        format.html { render action: 'new' }
        format.json { render json: @authority.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /authorities/1
  # PATCH/PUT /authorities/1.json
  def update
    respond_to do |format|
      if @authority.update(authority_params)
        format.html { redirect_to @authority, notice: 'Authority was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @authority.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authorities/1
  # DELETE /authorities/1.json
  def destroy
    @authority.destroy
    respond_to do |format|
      format.html { redirect_to authorities_url }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def authority_params
      params.require(:authority).permit(:name)
    end
end

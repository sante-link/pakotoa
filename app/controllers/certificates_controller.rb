class CertificatesController < ApplicationController
  respond_to :html

  load_and_authorize_resource :authority
  load_and_authorize_resource :certificate, through: :authority

  add_breadcrumb "authorities.index.title", "authorities_path"
  add_breadcrumb :authority_title, "authority_path(@authority)"
  add_breadcrumb "certificates.index.title", "authority_certificates_path(@authority)", except: :index

  # GET /certificates
  def index
  end

  # GET /certificates/1
  def show
  end

  # GET /certificates/new
  def new
  end

  # GET /certificates/1/edit
  def edit
  end

  # POST /certificates
  def create
    @certificate.save
    respond_with(@authority, @certificate)
  end

  # PATCH/PUT /certificates/1
  def update
    @certificate.update(certificate_params)
    respond_with(@authority, @certificate)
  end

  # DELETE /certificates/1
  def destroy
    @certificate.destroy
    respond_with(@authority, @certificate)
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def certificate_params
      params.require(:certificate).permit(:serial, :authority_id)
    end
end

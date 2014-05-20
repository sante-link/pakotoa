class CertificateAuthoritiesController < ApplicationController

  respond_to :html

  load_and_authorize_resource :certificate_authority

  add_breadcrumb "certificate_authorities.index.title", "certificate_authorities_path", except: :index

  # GET /certificate_authorities
  # GET /certificate_authorities.json
  def index
    @certificate_authorities = @certificate_authorities.order("name ASC")
  end

  # GET /certificate_authorities/1
  # GET /certificate_authorities/1.json
  def show
  end

  # GET /certificate_authorities/1/openssl_req
  def openssl_req
    render layout: false
  end

  # GET /certificate_authorities/1/openssl_ca
  def openssl_ca
    render layout: false
  end

  # GET /certificate_authorities/new
  def new
  end

  # GET /certificate_authorities/1/edit
  def edit
  end

  # POST /certificate_authorities
  # POST /certificate_authorities.json
  def create
    if @certificate_authority.save then
      @certificate_authority.subject_attributes.create(oid: Oid.find_by_name('countryName'), min: 2, max: 2, policy: 'match', default: 'FR')
      @certificate_authority.subject_attributes.create(oid: Oid.find_by_name('organizationalUnitName'), policy: 'match', default: @certificate_authority.name)
      @certificate_authority.subject_attributes.create(oid: Oid.find_by_name('commonName'), policy: 'supplied')
      @certificate_authority.subject_attributes.create(oid: Oid.find_by_name('emailAddress'), policy: 'supplied')
    end
    respond_with(@certificate_authority)
  end

  # PATCH/PUT /certificate_authorities/1
  # PATCH/PUT /certificate_authorities/1.json
  def update
    @certificate_authority.update(params[:certificate_authority])
    respond_with(@certificate_authority)
  end

  # PATCH/PUT /certificate_authorities/1/commit
  def commit
    root_ca_cert="#{Rails.root}/config/ssl/0.root/cacert.pem"
    ca_cert="#{@certificate_authority.directory}/cacert.pem"

    check = `openssl verify -CAfile "#{root_ca_cert}" "#{ca_cert}" 2>&1`

    if check == "#{ca_cert}: OK\n" then
      @certificate_authority.committed = true
      @certificate_authority.save
      flash[:notice] = "Certification Authority's certificate verified successfuly."
    else
      flash[:alert] = "<strong>Certification Authority's certificate could not be verified.</strong>#{simple_format(check)}".html_safe
    end

    respond_with(@certificate_authority)
  end

  # DELETE /certificate_authorities/1
  # DELETE /certificate_authorities/1.json
  def destroy
    @certificate_authority.destroy
    respond_with(@certificate_authority)
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def certificate_authority_params
      params.require(:certificate_authority).permit(:name, :basename)
    end
end

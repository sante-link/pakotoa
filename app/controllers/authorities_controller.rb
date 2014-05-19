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

  # GET /authorities/1/openssl_req
  def openssl_req
    render layout: false
  end

  # GET /authorities/1/openssl_ca
  def openssl_ca
    render layout: false
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
    if @authority.save then
      @authority.subject_attributes << SubjectAttribute.new(oid: Oid.find_by_name('countryName'), min: 2, max: 2, policy: 'match', default: 'FR')
      @authority.subject_attributes << SubjectAttribute.new(oid: Oid.find_by_name('organizationalUnitName'), policy: 'match', default: @authority.name)
      @authority.subject_attributes << SubjectAttribute.new(oid: Oid.find_by_name('commonName'), policy: 'supplied')
      @authority.subject_attributes << SubjectAttribute.new(oid: Oid.find_by_name('emailAddress'), policy: 'supplied')
    end
    respond_with(@authority)
  end

  # PATCH/PUT /authorities/1
  # PATCH/PUT /authorities/1.json
  def update
    @authority.update(params[:authority])
    respond_with(@authority)
  end

  # PATCH/PUT /authorities/1/commit
  def commit
    root_ca_cert="#{Rails.root}/config/ssl/0.root/cacert.pem"
    ca_cert="#{@authority.directory}/cacert.pem"

    check = `openssl verify -CAfile "#{root_ca_cert}" "#{ca_cert}" 2>&1`

    if check == "#{ca_cert}: OK\n" then
      @authority.committed = true
      @authority.save
      flash[:notice] = "Certification Authority's certificate verified successfuly."
    else
      flash[:alert] = "<strong>Certification Authority's certificate could not be verified.</strong>#{simple_format(check)}".html_safe
    end

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
      params.require(:authority).permit(:name, :basename)
    end
end

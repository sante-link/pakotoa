class CertificateAuthoritiesController < ApplicationController

  respond_to :html

  load_and_authorize_resource :certificate_authority

  skip_load_resource :certificate_authority, only: :update

  add_breadcrumb "certificate_authorities.index.title", "certificate_authorities_path", except: :index

  # GET /certificate_authorities
  # GET /certificate_authorities.json
  def index
    @certificate_authorities = @certificate_authorities.order('created_at DESC')
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

  # POST /certificate_authorities
  # POST /certificate_authorities.json
  def create
    if @certificate_authority.save then
      key = OpenSSL::PKey::RSA.new(params[:certificate_authority][:key_length].to_i)
      @certificate_authority.key = key

      certificate = OpenSSL::X509::Certificate.new

      subject = OpenSSL::X509::Name.parse(@certificate_authority.subject)
      if @certificate_authority.issuer then
        @issuer = @certificate_authority.issuer
        issuer_certificate = @issuer.certificate
        issuer_subject = OpenSSL::X509::Name.parse(@certificate_authority.issuer.subject)
        @issuer.password = params[:certificate_authority][:issuer_password]
      else
        @issuer = @certificate_authority
        issuer_certificate = certificate
        issuer_subject = subject
        @certificate_authority.next_serial = Random.rand(2**64)
      end

      certificate.version = 2
      certificate.serial = @issuer.next_serial!
      certificate.subject = subject
      certificate.issuer = issuer_subject
      certificate.public_key = key.public_key
      certificate.not_before = Time.now
      certificate.not_after = Chronic.parse(@certificate_authority.valid_until)
      ef = OpenSSL::X509::ExtensionFactory.new
      ef.subject_certificate = certificate
      ef.issuer_certificate = issuer_certificate
      certificate.add_extension(ef.create_extension("basicConstraints", "CA:TRUE", true))
      certificate.add_extension(ef.create_extension("keyUsage","keyCertSign, cRLSign", true))
      certificate.add_extension(ef.create_extension("subjectKeyIdentifier","hash",false))
      certificate.add_extension(ef.create_extension("authorityKeyIdentifier","keyid:always",false))
      @issuer.sign(certificate)

      @certificate_authority.certificate = certificate

      @certificate_authority.save
    end

    respond_with(@certificate_authority)
  rescue Exception => e
    @certificate_authority.destroy
    @certificate_authority.errors.add(:issuer_password, e.message + "" + e.backtrace.join('<br/>'))
    render 'new'
  end

  def edit
  end

  def update
    @certificate_authority = CertificateAuthority.find(params[:id])

    current_password = params[:certificate_authority].delete(:current_password)
    @certificate_authority.assign_attributes(params[:certificate_authority])

    if @certificate_authority.valid? then
      if @certificate_authority.password != current_password then
        @certificate_authority.password = current_password
        key = @certificate_authority.key
        @certificate_authority.password = params[:certificate_authority][:password]
        @certificate_authority.key = key
      end
      @certificate_authority.save
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
      params.require(:certificate_authority).permit(:subject, :key_length, :password, :password_confirmation, :issuer_id, :issuer_password, :current_password, :policy_id, :export_root, :valid_until, :certify_for)
    end
end

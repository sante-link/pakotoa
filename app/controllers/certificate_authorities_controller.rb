class CertificateAuthoritiesController < ApplicationController

  respond_to :html

  load_and_authorize_resource :certificate_authority

  add_breadcrumb "certificate_authorities.index.title", "certificate_authorities_path", except: :index

  # GET /certificate_authorities
  # GET /certificate_authorities.json
  def index
    @certificate_authorities = @certificate_authorities
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
      key = OpenSSL::PKey::RSA.new(params[:certificate_authority][:key_length].to_i)

      certificate = OpenSSL::X509::Certificate.new

      subject = OpenSSL::X509::Name.parse(@certificate_authority.subject)
      if @certificate_authority.issuer then
        issuer_certificate = OpenSSL::X509::Certificate.new(@certificate_authority.issuer.certificate)
        issuer_key = OpenSSL::PKey::RSA.new(@certificate_authority.issuer.key)
        issuer_subject = OpenSSL::X509::Name.parse(@certificate_authority.issuer.subject)
      else
        issuer_certificate = certificate
        issuer_key = key
        issuer_subject = subject
      end

      certificate.version = 2
      certificate.serial = 1 # FIXME
      certificate.subject = subject
      certificate.issuer = issuer_subject
      certificate.public_key = key.public_key
      certificate.not_before = Time.now
      certificate.not_after = Time.now + 2.years # FIXME
      ef = OpenSSL::X509::ExtensionFactory.new
      ef.subject_certificate = certificate
      ef.issuer_certificate = issuer_certificate
      certificate.add_extension(ef.create_extension("basicConstraints", "CA:TRUE", true))
      certificate.add_extension(ef.create_extension("keyUsage","keyCertSign, cRLSign", true))
      certificate.add_extension(ef.create_extension("subjectKeyIdentifier","hash",false))
      certificate.add_extension(ef.create_extension("authorityKeyIdentifier","keyid:always",false))
      certificate.sign(issuer_key, OpenSSL::Digest::SHA256.new)

      @certificate_authority.key = key.to_pem
      @certificate_authority.certificate = certificate.to_pem

      @certificate_authority.save!
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
      params.require(:certificate_authority).permit(:subject, :key_length, :issuer_id)
    end
end

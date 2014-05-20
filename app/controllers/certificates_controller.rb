class CertificatesController < ApplicationController
  respond_to :html

  load_and_authorize_resource :certificate_authority
  load_and_authorize_resource :certificate, through: :certificate_authority

  add_breadcrumb "certificate_authorities.index.title", "certificate_authorities_path"
  add_breadcrumb :certificate_authority_title, "certificate_authority_path(@certificate_authority)"
  add_breadcrumb "certificates.index.title", "certificate_authority_certificates_path(@certificate_authority)", except: :index

  # GET /certificates
  def index
  end

  # GET /certificates/1
  def show
  end

  # GET /certificates/new
  def new
  end

  # POST /certificates
  def create
    case params[:certificate][:method]
      when "csr"
        req = OpenSSL::X509::Request.new(params[:certificate][:csr])
        @certificate.subject = req.subject.to_s

        cert = OpenSSL::X509::Certificate.new
        cert.version = 2
        cert.serial = @certificate_authority.next_serial!
        cert.subject = req.subject
        cert.issuer = OpenSSL::X509::Name.parse(@certificate_authority.subject)
        cert.public_key = req.public_key
        cert.not_before = Time.now
        cert.not_after = Time.now + 7.days # FIXME
        ef = OpenSSL::X509::ExtensionFactory.new
        ef.subject_certificate = cert
        ef.issuer_certificate = OpenSSL::X509::Certificate.new(@certificate_authority.certificate)
        cert.add_extension(ef.create_extension("keyUsage","digitalSignature", true))
        cert.add_extension(ef.create_extension("subjectKeyIdentifier","hash",false))
        cert.sign(OpenSSL::PKey::RSA.new(@certificate_authority.key), OpenSSL::Digest::SHA256.new)

        @certificate.certificate = cert.to_pem
        @certificate.serial = cert.serial.to_s(16)
        @certificate.save
      when "spkac"
        if params[:public_key].nil?
          @certificate.errors.add(:public_key, :not_set)
        else
          @certificate.save
          f = File.new("/tmp/key.spkac", "w")
          f.write("SPKAC=#{params[:public_key].split.join}\n");
          attr_usage = {}
          @certificate_authority.subject_attributes.order("position").each_with_index do |attr,i|
            attr_usage[attr.oid.name] ||= 0
            value = params["attr_#{i}"] || attr.default
            if ! value.blank? then
              f.write("#{attr_usage[attr.oid.name]}.#{attr.oid.name}=#{value}\n")
            end
            attr_usage[attr.oid.name] += 1
          end
          f.close
          # openssl ca -config config/ssl/openssl.cnf -name CA_santelink -spkac /tmp/key.spkac -batch
        end
      when "insecure"
    end
    respond_with(@certificate_authority, @certificate)
  end

  # DELETE /certificates/1
  def destroy
    @certificate.destroy
    respond_with(@certificate_authority, @certificate)
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def certificate_params
      params.require(:certificate).permit(:method, :csr)
    end
end

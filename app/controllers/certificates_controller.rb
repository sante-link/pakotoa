# frozen_string_literal: true

class CertificatesController < ApplicationController
  # respond_to :html

  load_and_authorize_resource :certificate_authority
  load_and_authorize_resource :certificate, through: :certificate_authority

  skip_load_resource :certificate, only: [:index, :create]

  add_breadcrumb "certificate_authorities.index.title", "certificate_authorities_path"
  add_breadcrumb :certificate_authority_title, "certificate_authority_path(@certificate_authority)"
  add_breadcrumb "certificates.index.title", "certificate_authority_certificates_path(@certificate_authority)", except: :index

  # GET /certificates
  def index
    @certificates = Certificate.signed_by(@certificate_authority.subject).order("created_at DESC")
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
      @certificate = @certificate_authority.sign_certificate_request(params[:certificate][:csr])
    when "spkac"
      if params[:public_key].nil?
        @certificate.errors.add(:public_key, :not_set)
      else
        @certificate.save
        f = File.new("/tmp/key.spkac", "w")
        f.write("SPKAC=#{params[:public_key].split.join}\n")
        attr_usage = {}
        @certificate_authority.subject_attributes.order("position").each_with_index do |attr, i|
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

  def revoke
    @certificate.update_attributes(revoked_at: Time.now.utc)
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

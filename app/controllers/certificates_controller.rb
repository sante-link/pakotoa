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
    case params[:method]
      when "csr"
      when "spkac"
        if params[:public_key].nil?
          @certificate.errors.add(:public_key, :not_set)
        else
          @certificate.save
          f = File.new("/tmp/key.spkac", "w")
          f.write("SPKAC=#{params[:public_key].split.join}\n");
          attr_usage = {}
          @authority.subject_attributes.order("position").each_with_index do |attr,i|
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

module Pakotoa
  class API < Grape::API
    version 'v1', vendor: 'Médispo', cascade: false

    format :json

    rescue_from :all

    helpers do
      def current_token
        env['api.token']
      end
      def current_user
        @current_user ||= Acl::User.find(current_token.resource_owner_id) if current_token
      end
    end

    doorkeeper_for :all

    desc 'Creates a Certificate from the given Certificate Sign Request'
    params do
      requires :csr, type: String, desc: 'The Certificate Sign Request (CSR)'
      requires :issuer, type: String, desc: 'The Certificate Authority (CA) who will sign the CSR'
      optional :export_name, type: String, desc: 'The pathname to save the generated certificate to (if supported)'
    end
    post :sign do
      issuer = CertificateAuthority.find_by(subject: params[:issuer])
      raise StandardError.new("Certificate Authority not found") if issuer.nil?
      certificate = issuer.sign_certificate_request(params[:csr], params[:export_name])
      raise StandardError.new("Certificate not persisted: #{certificate.errors.full_messages.join("\n")}") unless certificate.persisted?
      { certificate: certificate.certificate.to_pem }
    end
  end
end

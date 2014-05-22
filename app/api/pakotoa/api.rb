module Pakotoa
  class API < Grape::API
    prefix 'api'
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

    doorkeeper_for :all, except: [ :'api-docs', :'api-docs/:name' ]

    resource :certificates do
      desc 'Creates a Certificate from the given Certificate Sign Request'
      params do
        requires :csr, type: String, desc: 'The Certificate Sign Request (CSR)'
        requires :issuer, type: String, desc: 'The subject of the Certificate Authority (CA) who will sign the CSR'
        optional :export_name, type: String, desc: 'The pathname to save the generated certificate to (if supported)'
      end
      post :sign do
        issuer = CertificateAuthority.find_by(subject: params[:issuer])
        raise StandardError.new("Certificate Authority not found") if issuer.nil?
        certificate = issuer.sign_certificate_request(params[:csr], params[:export_name])
        raise StandardError.new("Certificate not persisted: #{certificate.errors.full_messages.join("\n")}") unless certificate.persisted?
        { certificate: certificate.certificate.to_pem }
      end

      desc 'Revokes a Certificate'
      params do
        requires :issuer, type: String, desc: 'The suject of the Certificate Authority (CA) who emitted the certificate to revoke'
        optional :serial, type: String, desc: 'The serial number of the certificate to revoke (as hex string)'
        optional :suject, type: String, desc: 'The subject of the certificate to revoke'
      end
      patch :revoke do
        issuer = CertificateAuthority.find_by(subject: params[:issuer])
        raise StandardError.new("Certificate Authority not found") if issuer.nil?

        if params[:serial] then
          certificate = issuer.certificates.find_by(serial: params[:serial])
        elsif params[:subject] then
          certificate = issuer.certificates.find_by(subject: params[:subject])
        else
          raise StandardError.new("issuer or subject is missing")
        end
        raise StandardError.new("certificate not found") if certificate.nil?

        certificate.update_attributes!(revoked_at: Time.now.utc)

        { status: 'OK' }
      end
    end

    add_swagger_documentation mount_path: 'api-docs', api_version: 'v1', hide_documentation_path: true
  end
end

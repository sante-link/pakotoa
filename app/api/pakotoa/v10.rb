module Pakotoa
  class V10 < Grape::API
    prefix 'api'
    version '1.0', using: :accept_version_header, vendor: 'Médispo', cascade: true

    format :json

    rescue_from :all

    helpers do
      def current_token
        env['api.token']
      end
      def current_user
        @current_user ||= User.find(current_token.resource_owner_id) if current_token
      end
    end

    doorkeeper_for :all, except: [ :'api-docs', :'api-docs/:name' ]

    desc 'Returns the API version'
    get :version, protected: false do
      { version: '1.0' }
    end

    resource :certificate_authoritiess do
      desc 'Creates a Certificate from the given Certificate Sign Request'
      params do
        requires :csr, type: String, desc: 'The Certificate Sign Request (CSR)'
        requires :issuer, type: String, desc: 'The subject of the Certificate Authority (CA) who will sign the CSR'
        optional :export_name, type: String, desc: 'The pathname to save the generated certificate to (if supported)'
      end
      post :sign, notes: 'A previous OAuth2 authentication is required.', http_codes: [ [400, 'Certificate Authority not found'], [400, 'Cannot create certificate'] ] do
        issuer = CertificateAuthority.find_by(subject: params[:issuer])
        error!('Certificate Authority not found', 400) if issuer.nil?
        certificate = issuer.sign_certificate_request(params[:csr], params[:export_name])
        error!("certificate not persisted: #{certificate.errors.full_messages.join("\n")}", 400) unless certificate.persisted?
        { certificate: certificate.certificate.to_pem }
      end

      desc 'Revokes a Certificate'
      params do
        requires :issuer, type: String, desc: 'The suject of the Certificate Authority (CA) who emitted the certificate to revoke'
        optional :serial, type: String, desc: 'The serial number of the certificate to revoke (as hex string)'
        optional :suject, type: String, desc: 'The subject of the certificate to revoke'
      end
      patch :revoke, notes: 'A previous OAuth2 authentication is required.', http_codes: [ [400, 'Certificate Authority not found'], [400, 'serial or subject must be set'], [400, 'certificate not found'] ] do
        issuer = CertificateAuthority.find_by(subject: params[:issuer])
        error!('Certificate Authority not found', 400) if issuer.nil?

        if params[:serial] then
          certificate = issuer.certificates.find_by(serial: params[:serial])
        elsif params[:subject] then
          certificate = issuer.certificates.find_by(subject: params[:subject])
        else
          error!('serial or subject must be set', 400)
        end
        error!('certificate not found', 400) if certificate.nil?

        certificate.update_attributes!(revoked_at: Time.now.utc)

        { status: 'OK' }
      end

      desc "Returns the CRL of the provided Certificate Authority"
      params do
        requires :issuer, type: String, desc: 'The subject of the Certificate Authority to get the CRL from.'
      end
      get :crl, protected: false, http_codes: [ [400, 'Certificate Authority not found'] ] do
        ca = CertificateAuthority.find_by(subject: params[:issuer])
        error!('Certificate Authority not found', 400) if ca.nil?
        { crl: ca.crl.to_pem }
      end
    end

    add_swagger_documentation mount_path: 'api-docs', api_version: '1.0', hide_documentation_path: true
  end
end

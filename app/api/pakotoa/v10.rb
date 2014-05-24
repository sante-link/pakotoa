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

    desc 'Returns the API version', {
      http_codes: [
        [200, 'Success'],
      ],
      notes: <<-NOTES
      For any API request, clients can pass the desired API version in the `Accept-Version` HTTP header.

      If no header is set, the latest version of the API will be used.

      This function can be used to check you client API version selection (by providing an `Accept-Version` HTTP header) or the current version of the API (by providing no `Accept-Version` HTTP header).

      #### Sample Response

      ```
      {
        "version": "1.0"
      }
      ```
      NOTES
    }
    get :version, protected: false do
      { version: '1.0' }
    end

    resource :certificate_authorities do
      desc 'Creates a Certificate from the given Certificate Sign Request', {
        http_codes: [
          [200, 'Success'],
          [400, 'Certificate Authority not found'],
          [400, 'Cannot create certificate'],
          [401, 'Not authorized'],
        ],
        notes: <<-NOTES
        A previous OAuth2 authentication is required.

        #### Sample Response

        ```
        {
          "certificate": "-----BEGIN CERTIFICATE-----
        MIIDKDCCAhCgAwIBAgIBATANBgkqhkiG9w0BAQsFADAxMQswCQYDVQQGEwJGUjEQ
        MA4GA1UECgwHUGFrb3RvYTEQMA4GA1UEAwwHVGVzdCBDQTAeFw0xNDA1MjQwNzQ3
        MTBaFw0xNjA1MjQwNzQ3MTBaMEsxCzAJBgNVBAYTAkZSMRAwDgYDVQQKDAdQYWtv
        dG9hMQ8wDQYDVQQLDAZTYW1wbGUxGTAXBgNVBAMMEFRlc3QgQ2VydGlmaWNhdGUw
        ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC8XxKJ3o1VZVyVfYQv/HWL
        BIcHlwzGv70Z3vFsDPSbaSKmjkXQmdj1lKX8H7Y09dwCoc0GFozw5nzRebuYK8ka
        cXrWbN+sTr+rsAg86NzQHyCQ6AexGUy8yDu09r5CafnzDrZ1QNferoUfwBp7XbvZ
        hny3Acj7D0XotEUNFDcVod+nVGInpOf+aU6b+TkO3BM1UNidrmqh5lvAvf0i2CCl
        GnQvXVrbjwFiTX8TtVf6ST8HdzV1T/Of18DC3IILNh3VM0+DsleVWR5e74xUnIxy
        LGyyXic5+iHXl0RDUnksns+Y6uNl4m7Z/sf49m+5vm/d/f9vT3wlHIx9uuift+JL
        AgMBAAGjMTAvMA4GA1UdDwEB/wQEAwIHgDAdBgNVHQ4EFgQU0XNLS8JwfAEzDM0P
        klIofAACZsgwDQYJKoZIhvcNAQELBQADggEBAIwFt7zDgXdvw7qPXZNzO+PeKPbt
        InovY2H7SpiqcGr1cGTX5dCAEwoL2tX76JGA2DE7VdTNevRA3R3CS5abevLw7z5X
        3c0TbBNk9bWBRfaF5Wwx/9RdhCurKzDkZKTNS7hrIXUph6gqT3fD1XFIrvcRQQFb
        329SgKENJHHWDHljCTD9EwqQSuSqyAIThpmCW3IdE1DdnCpy1AbhtKVqWweZWz+t
        9Y5wKZHuu6N8gvmb/x1f61rrC1ELFWjgUbtR4mSDrvd206Ez9LUYsF2quEYrUjsM
        79Bh1nAU9j2YFmQb+7dJWkeLj7PgwHXtERTBEhahU0R0QN5FF3cPRXyC+Ec=
        -----END CERTIFICATE-----
        "
        }
        ```
        NOTES
      }
      params do
        requires :csr, type: String, desc: 'The Certificate Sign Request (CSR)'
        requires :issuer, type: String, desc: 'The subject of the Certificate Authority (CA) who will sign the CSR'
        optional :export_name, type: String, desc: 'The pathname to save the generated certificate to (if supported)'
      end
      post :sign do
        issuer = CertificateAuthority.find_by(subject: params[:issuer])
        error!('Certificate Authority not found', 400) if issuer.nil?
        certificate = issuer.sign_certificate_request(params[:csr], params[:export_name])
        error!("certificate not persisted: #{certificate.errors.full_messages.join("\n")}", 400) unless certificate.persisted?
        { certificate: certificate.certificate.to_pem }
      end

      desc 'Revokes a Certificate', {
        http_codes: [
          [200, 'Success'],
          [400, 'Certificate Authority not found'],
          [400, 'serial or subject must be set'],
          [400, 'certificate not found'],
          [401, 'Not authorized'],
        ],
        notes: <<-NOTES
        A previous OAuth2 authentication is required.

        Either a `serial` or `subject` parameter must be set.

        #### Sample Response

        ```
        {
          "status": "ok"
        }
        ```
        NOTES
      }
      params do
        requires :issuer, type: String, desc: 'The suject of the Certificate Authority (CA) who emitted the certificate to revoke'
        optional :serial, type: String, desc: 'The serial number of the certificate to revoke (as hex string)'
        optional :suject, type: String, desc: 'The subject of the certificate to revoke'
      end
      patch :revoke do
        issuer = CertificateAuthority.find_by(subject: params[:issuer])
        error!('Certificate Authority not found', 400) if issuer.nil?

        if params[:serial] then
          certificate = issuer.certificates.find(serial: params[:serial])
        elsif params[:subject] then
          certificate = issuer.certificates.where('subject = ? AND (revoked_at IS NULL OR not_after > ?)', params[:subject], Time.now).first
        else
          error!('serial or subject must be set', 400)
        end
        error!('certificate not found', 400) if certificate.nil?

        certificate.update_attributes!(revoked_at: Time.now.utc)

        { status: 'OK' }
      end

      desc "Returns the CRL of the provided Certificate Authority", {
        http_codes: [
          [200, 'Success'],
          [400, 'Certificate Authority not found'],
        ],
        notes: <<-NOTES
          The Certificate Revokation List (CRL) is returned pem-encoded.

          #### Sample Response

          ```
          {
            "crl": "-----BEGIN X509 CRL-----
          MIIBeTBjAgEAMA0GCSqGSIb3DQEBCwUAMDExCzAJBgNVBAYTAkZSMRAwDgYDVQQK
          DAdQYWtvdG9hMRAwDgYDVQQDDAdUZXN0IENBFw0xNDA1MjQwNzIwMzhaFw0xNDA1
          MzEwNzIwMzhaMA0GCSqGSIb3DQEBCwUAA4IBAQCNhdxztT+5BceXmSN9R63yqhtn
          g9e1b4nV4m0eoo5KFOhYNnyCN/gBuA4dA/gv356IafAg50S2LX5EkDpfuV21ROqV
          VGM9fzoNTELYquLSq4aTtr65NWcYHtc0sfrGTJnsn5b8ryGqdnIvwP2lU809HBDf
          ngmKf8meLWYi5EQQTbR2lQXs9Dmzqc52nTDY7NHhn2Or37OafLJchJGr82VdJzwl
          8StWAQXHmGIhbsK7EWR2goGKpfbnRz1RZS9HsUpEGvBPttDOG2pKgzbjZ982N3N/
          vOnRWN0hQRUKyA2K24DwXTVs7KrpenJ+mxIIsnZ9tiI+/Q5FRZcM7cFWYT8N
          -----END X509 CRL-----
          "
          }
          ```
        NOTES
      }
      params do
        requires :issuer, type: String, desc: 'The subject of the Certificate Authority to get the CRL from.'
      end
      get :crl, protected: false do
        ca = CertificateAuthority.find_by(subject: params[:issuer])
        error!('Certificate Authority not found', 400) if ca.nil?
        { crl: ca.crl.to_pem }
      end
    end

    add_swagger_documentation mount_path: 'api-docs', api_version: '1.0', hide_documentation_path: true, markdown: true
  end
end

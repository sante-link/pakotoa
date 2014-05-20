class Api::V1::CertificateSignRequestsController < ApplicationController
  doorkeeper_for :all
  protect_from_forgery with: :null_session

  skip_authorization_check

  def sign
    issuer = CertificateAuthority.find_by(subject: params[:issuer])

    certificate = issuer.sign_certificate_request(params[:csr])

    render json: {status: 'OK', certificate: certificate.certificate.to_pem}
  end

  def plop
    render json: {status: 'OK'}
  end
end

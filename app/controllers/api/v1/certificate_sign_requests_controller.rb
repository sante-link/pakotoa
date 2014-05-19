class Api::V1::CertificateSignRequestsController < ApplicationController
  doorkeeper_for :all
  protect_from_forgery with: :null_session

  skip_authorization_check

  def sign
    OpenSSL::X509::Request.new(params['csr'])

    render json: {status: 'OK'}
  end

  def plop
    render json: {status: 'OK'}
  end
end

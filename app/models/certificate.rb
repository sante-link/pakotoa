class Certificate < ActiveRecord::Base
  belongs_to :issuer, class_name: 'CertificateAuthority'

  attr_accessor :method, :csr
end

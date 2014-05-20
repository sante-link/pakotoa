class Certificate < ActiveRecord::Base
  belongs_to :issuer, class_name: 'CertificateAuthority'
end

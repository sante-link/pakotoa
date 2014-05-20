class CertificateAuthority < Certificate
  has_many :affiliations, dependent: :destroy
  has_many :users, through: :affiliations
  has_many :certificates, dependent: :destroy, foreign_key: "issuer_id"
  has_many :subject_attributes, dependent: :destroy

  validates :password, confirmation: true

  attr_accessor :key_length, :password, :issuer_password

  after_initialize do
    self.key_length ||= 2048
    self.next_serial ||= 1
  end

  def next_serial!
    serial = self.next_serial
    update_attributes!(next_serial: (next_serial || 0) + 1)
    return serial
  end
end

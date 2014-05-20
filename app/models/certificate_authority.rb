class CertificateAuthority < Certificate
  has_many :affiliations, dependent: :destroy
  has_many :users, through: :affiliations
  has_many :certificates, dependent: :destroy, foreign_key: "issuer_id"
  has_many :subject_attributes, dependent: :destroy

  validates :password, confirmation: true

  attr_accessor :key_length, :password, :issuer_password

  def initialize(params = {})
    @key_length = 2048
    super(params)
  end
end

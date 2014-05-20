class CertificateAuthority < Certificate
  has_many :affiliations, dependent: :destroy
  has_many :users, through: :affiliations
  has_many :certificates, dependent: :destroy, foreign_key: "issuer_id"
  has_many :subject_attributes, dependent: :destroy

  attr_accessor :key_length

  def initialize(params = {})
    @key_length = 2048
    super(params)
  end
end

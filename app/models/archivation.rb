class Archivation < ApplicationRecord
  STRATEGIES = %w(auto crawl sitemap url urls)
  RATE_LIMIT_SEC = 60 * 60 * 24
  RATE_LIMITED_STRATEGIES = [nil, '', 'auto', 'crawl', 'sitemap'].freeze
  STATUSES = {
    queued: 1,
    started: 2,
    finished: 3,
    errored: 4
  }.freeze

  before_validation :set_uuid

  validates :url, presence: true
  validates :host, presence: true
  validates :strategy, inclusion: { in: STRATEGIES, message: '%{value} is not a valid strategy' }

  validate :validate_url
  validate :validate_host_rate_limit, on: :create

  scope :within_rate_limit, ->(duration = RATE_LIMIT_SEC.seconds) {
    where.not(status: :errored).
      where.not(stats: { total: 0 }).
      where(strategy: RATE_LIMITED_STRATEGIES).
      where('created_at > ?', duration.ago)
  }

  enum status: STATUSES

  def set_uuid
    return if self.uuid.present?

    self.uuid = SecureRandom.uuid
  end

  def archive_url
    "https://web.archive.org/web/*/#{url}"
  end

  def validate_host_rate_limit
    return unless RATE_LIMITED_STRATEGIES.include?(strategy)

    rate_limit = CoolDownRateLimit.new(self.host, cooldown: RATE_LIMIT_SEC.seconds)
    return unless rate_limit.throttled?

    errors.add(:host, rate_limit.error)
  end

  def validate_url
    return if ValidateURL.valid?(url)

    errors.add(:url, 'must be a valid, non-blacklisted, URL (with http(s))')
  end
end

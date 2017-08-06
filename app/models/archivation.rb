class Archivation < ApplicationRecord
  RATE_LIMIT_SEC = 60 * 60 * 24
  RATE_LIMITED_STRATEGIES = [nil, '', 'auto', 'crawl', 'sitemap'].freeze

  validates :url, presence: true

  validate :validate_url
  validate :validate_url_rate_limit, on: :create

  scope :within_rate_limit, ->(duration = RATE_LIMIT_SEC.seconds) {
    where(strategy: RATE_LIMITED_STRATEGIES).
      where('created_at > ?', duration.ago)
  }

  enum status: {
    queued: 1,
    started: 2,
    finished: 3,
    errored: 4
  }

  def archive_url
    "https://web.archive.org/web/*/#{url}"
  end

  def validate_url_rate_limit
    return unless RATE_LIMITED_STRATEGIES.include?(strategy)

    rate_limit = CoolDownRateLimit.new(self.url, cooldown: RATE_LIMIT_SEC.seconds)
    return unless rate_limit.throttled?

    errors.add(:url, rate_limit.error)
  end

  def validate_url
    return if ValidateURL.valid?(url)

    errors.add(:url, 'must be a valid URL (with http(s))')
  end
end

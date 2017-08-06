class CoolDownRateLimit
  attr_reader :host, :cooldown_duration

  def initialize(host, cooldown:)
    @host = host
    @cooldown_duration = cooldown
  end

  def throttled?
    !last_archivation.nil?
  end

  def allowed_at
    return Time.now unless last_archivation

    last_archivation.created_at + cooldown_duration
  end

  def error
    return unless throttled?

    diff_seconds = allowed_at - Time.now

    if diff_seconds < 60
      text = "(~#{(diff_seconds).round(0)} seconds)"
    elsif diff_seconds > 3600
      text = "(~#{(diff_seconds / 3600.0).round(0)} hours)"
    else
      text = "(~#{(diff_seconds / 60.0).round(0)} minutes)"
    end

    "to soon for resubmission of #{host}, please try again at #{allowed_at} #{text}"
  end

  def last_archivation
    @last_archivation ||= Archivation.
                                      within_rate_limit(cooldown_duration).
                                      where(host: host).
                                      last
  end
end

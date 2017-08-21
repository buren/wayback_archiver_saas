class CreateArchivation
  def self.call(archivation)
    archivation.strategy = archivation.strategy.to_s.strip.downcase
    archivation.status = :queued
    archivation.url = normalize_url(archivation.url)
    archivation.host = URI.parse(archivation.url).host

    if archivation.save
      ArchivationJob.perform_later(archivation: archivation)

      yield(archivation, true)
    else
      yield(archivation, false)
    end
  end

  def self.normalize_url(raw_url)
    url = raw_url.to_s.strip
    return '' if url.blank?

    unless url.start_with?('http://') || url.start_with?('https://')
      return "http://#{url}"
    end

    url
  end
end

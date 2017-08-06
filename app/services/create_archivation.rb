class CreateArchivation
  def self.call(archivation)
    archivation.strategy = archivation.strategy.to_s.strip.downcase
    archivation.status = :queued
    archivation.url = archivation.url.to_s.strip
    archivation.host = URI.parse(archivation.url).host

    if archivation.save
      ArchivationJob.perform_later(archivation: archivation)

      yield(archivation, true)
    else
      yield(archivation, false)
    end
  end
end

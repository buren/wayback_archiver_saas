class ArchivationMailer < ApplicationMailer
  def success(archivation:, email:, total:)
    @archivation = archivation
    @url = archivation.url
    @archive_url = archivation.archive_url
    @total = total

    mail(to: email, subject: "Archivation finished: #{@url}")
  end

  def failed(archivation:, email:)
    @archivation = archivation
    @url = archivation.url
    @archive_url = archivation.archive_url

    mail(to: email, subject: "Failed to archive: #{@url}")
  end
end

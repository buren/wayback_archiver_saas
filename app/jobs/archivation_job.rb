class ArchivationJob < ApplicationJob
  queue_as :default

  def perform(archivation:)
    archivation.update!(status: 'started')

    strategy = archivation.strategy || 'auto'
    notification_email = archivation.notification_email

    results = begin
                WaybackArchiver.archive(archivation.url, strategy: strategy)
              rescue => e
                Rails.logger.error "Archivation of ##{archivation.id} failed, with #{e}, #{e.message}"
                nil
              end

    if results && notification_email
      ArchivationMailer.success(
        archivation: archivation,
        email: notification_email,
        total: results.length
      ).deliver_later
    elsif notification_email
      ArchivationMailer.failed(
        archivation: archivation,
        email: notification_email
      ).deliver_later
    end

    archivation.update!(status: results ? :finished : :errored)
  end
end

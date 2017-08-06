class ArchivationJob < ApplicationJob
  queue_as :default

  def perform(archivation:)
    archivation.update!(status: 'started')

    strategy = archivation.strategy || 'auto'
    notification_email = archivation.notification_email

    success = false
    begin
      WaybackArchiver.archive(archivation.url, strategy: strategy)
      success = true
    rescue => e
      Rails.logger.error "Archivation of ##{archivation.id} failed, with #{e}, #{e.message}"
    end

    ArchivationMailer.send(
      success ? :success : :failed,
      archivation: archivation,
      email: notification_email
    ).deliver_later if notification_email

    archivation.update!(status: success ? :finished : :errored)
  end
end

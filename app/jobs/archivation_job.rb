class ArchivationJob < ApplicationJob
  queue_as :default

  def perform(archivation:)
    archivation.update!(status: 'started')

    strategy = archivation.strategy || 'auto'
    notification_email = archivation.notification_email

    results = begin
                WaybackArchiver.archive(archivation.url, strategy: strategy)
              rescue => e
                message = "Archivation of ##{archivation.id} failed, with #{e}, #{e.message}"
                Rails.logger.error message
                [notification_email, ENV['ADMIN_EMAIL']].compact.each do |email|
                  ArchivationMailer.failed(
                    archivation: archivation,
                    email: email
                  ).deliver_later
                end

                archivation.update!(
                  status: :errored,
                  stats: { total: total, error: message }
                )
                return
              end

    total = results.length

    archivation.update!(
      status: :finished,
      stats: { total: total }
    )

    ArchivationMailer.success(
      archivation: archivation,
      email: notification_email,
      total: total
    ).deliver_later if notification_email
  end
end

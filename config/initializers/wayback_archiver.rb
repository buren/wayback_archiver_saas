WaybackArchiver.logger = Rails.logger
WaybackArchiver.concurrency = Integer(ENV.fetch('WAYBACK_ARCHIVER_CONCURRENCY', WaybackArchiver.concurrency))

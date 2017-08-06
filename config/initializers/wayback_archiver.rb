WaybackArchiver.logger = Rails.logger
WaybackArchiver.concurrency = Integer(ENV.fetch('WAYBACK_ARCHIVER_CONCURRENCY', WaybackArchiver.concurrency))
WaybackArchiver.max_limit = Integer(ENV.fetch('WAYBACK_ARCHIVER_DEFAULT_MAX_LIMIT', 10_000))

module ArchivationHelper
  def archivation_status_badge(archivation)
    badge_name = case archivation.status
                 when 'queued' then 'secondary'
                 when 'started' then 'primary'
                 when 'finished' then 'success'
                 when 'errored' then 'danger'
                 else
                   'secondary'
                 end

    content_tag(:span, archivation.status.titleize, class: "badge badge-#{badge_name}")
  end
end

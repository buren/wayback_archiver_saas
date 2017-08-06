class ArchivationsController < ApplicationController
  protect_from_forgery with: :null_session

  def show
    uuid = params[:id].presence || raise(ActiveRecord::RecordNotFound)
    render json: Archivation.find_by!(uuid: uuid)
  end

  def create
    archivation = Archivation.new(archivation_params)

    create_and_render(archivation)
  end

  def ping
    sitemap = params[:sitemap]
    if sitemap.blank? || !ValidateURL.valid?(sitemap)
      render json: {
        status: 422,
        errors: ['sitemap query string must be a valid URL']
      }
      return
    end

    notification_email = params[:notification_email]

    archivation = Archivation.new(
      url: sitemap,
      notification_email: notification_email,
      strategy: 'sitemap'
    )

    create_and_render(archivation)
  end

  private

  def create_and_render(archivation)
    CreateArchivation.call(archivation) do |archivation, success|
      if success
        render json: archivation, status: 201
      else
        render json: {
          status: 422,
          errors: archivation.errors.full_messages
        }, status: 422
      end
    end
  end

  def archivation_params
    params.require(:archivation).permit(:url, :notification_email, :strategy)
  end
end

# Wayback Archiver - SAAS

Wayback Archiver - Software as a Service (SAAS)

__Built with__:

* Ruby v2.4
* PostgreSQL > 9.3
* Redis > 3

Sidekiq UI @ `/sidekiq`.

## API

### Create archivation

_Required_: `url`.
_Optional_: `strategy`, `notification_email`.

#### `GET /ping?sitemap=http://example.com`

Also supports `notification_email` param.

#### `POST /archivations/`

_Payload_:

```json
{
	"archivation": {
		"url": "http://example.com",
		"strategy": "crawl",
		"notification_email": "test@example.com"
	}
}
```

_Response success_:

```json
{
  "id": 32,
  "url": "http://example.com",
  "strategy": "crawl",
  "status": "queued",
  "notification_email": "test@example.com",
  "created_at": "2017-08-05T23:56:51.905Z",
  "updated_at": "2017-08-05T23:56:51.905Z"
}
```

_Response error_:

```json
{
  "status": 422,
  "errors": [
      "Url to soon for URL resubmission please try again at 2017-08-06 23:41:17 UTC (~24 hours)"
  ]
}
```

## Configuration

Env. variables

* `ADMIN_USERNAME` - Admin username
* `ADMIN_PASSWORD` - Admin password
* `SENDGRID_USERNAME` - Sendgrid username
* `SENDGRID_PASSWORD` - Sendgrid password
* `DEFAULT_FROM_EMAIL` - Default mailer from email address
* `REDIS_URL` - Redis URL

## Deployment

```
$ heroku create <your_name>
$ git push heroku master
$ heroku run rails db:migrate
$ heroku addons:create heroku-redis:hobby-dev
$ heroku addons:create sendgrid:starter
```

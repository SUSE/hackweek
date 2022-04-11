# Akismet spam protection
Rails.application.config.rakismet.key = ENV.fetch('HACKWEEK_RAKISMET_KEY', nil)
Rails.application.config.rakismet.url = ENV.fetch('HACKWEEK_RAKISMET_URL', 'https://hackweek.opensuse.org')

Sentry.init do |config|
  config.dsn = ENV['HACKWEEK_SENTRY_DSN']
  config.breadcrumbs_logger = [:active_support_logger]

  # To activate performance monitoring, set one of these options.
  # We recommend adjusting the value in production:
  # config.traces_sample_rate = 0.5
  # or
  # config.traces_sampler = lambda do |_context|
  #  true
  # end
end

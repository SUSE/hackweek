module AkismetValidation
  extend ActiveSupport::Concern

  def akismet_spam
    return unless Rails.env.production?
    return unless spam?
    return if originator.email.end_with?('@suse.com')
    return if originator.email.end_with?('@opensuse.org')

    errors.add(:base, message: 'is spam')
  end
end

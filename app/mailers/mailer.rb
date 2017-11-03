class Mailer < ActionMailer::Base

  include ApplicationHelper

  default :from => "'#{I18n.t('dbm_email')}' <no-reply@fenux.fi>"

  def send_feedback_email(options={})
    @message = options[:message]
    I18n.with_locale(I18n.locale) do
      mail(:to => options[:recipient_emails], :subject => options[:subject])
    end
  end

  def send_order_for_dbm_email(options={})
    @message = options[:message]
    I18n.with_locale(I18n.locale) do
      mail(:to => options[:recipient_email], :subject => options[:subject])
    end
  end
  
  def send_login_info_by_email(options)
    @message = options[:message]
    I18n.with_locale(I18n.locale) do
      mail(:to => options[:recipient_email], :subject => options[:subject])
    end
  end
end
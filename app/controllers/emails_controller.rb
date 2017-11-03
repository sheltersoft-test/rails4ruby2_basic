class EmailsController < ApplicationController

  include ApplicationHelper
  
  before_action :authenticate_user!
  
  def send_feedback_email
    begin
      @error = true
      if params[:subject].present? and params[:message].present? and current_user.present?
        @feedback = @current_brand.feedbacks.new(:sender => current_user, :subject => params[:subject], :message => params[:message])
        if @feedback.save
          options = {
                      :sender_email => @feedback.sender.email,
                      :message => @feedback.message,
                      :subject => @feedback.subject.humanize,
                      :recipient_emails => Settings.feedback.recipient_emails
                    }
          Mailer.delay.send_feedback_email(options)
          @error = false
        end
      end
   rescue Exception => e
      @error = true
    end
  end


  def order_dbm_email
    begin
      params[:recipient_email].each do |key,value|
        options = {
                    :message => params[:message],
                    :subject => params[:subject],
                    :recipient_email => value
                  }
        Mailer.delay.send_order_for_dbm_email(options)
      end
      @success = true      
    rescue Exception => e
      @success = false
    end
    respond_to do |format|
      format.js { render :partial => "dbm_order_email" }
    end
  end

  def send_login_info_email
    user = @current_brand.users.find(params[:id])
    secure_pass = SecureRandom.hex(4)
    user.update_attributes!(:password => secure_pass, :password_confirmation => secure_pass)
    message = params[:message].gsub('********', secure_pass)
    options = {
                :message => message,
                :subject => params[:subject],
                :recipient_email => params[:recipient_email]
              }
    Mailer.delay.send_login_info_by_email(options)
    flash.keep[:notice] = t("executive.sent_login_info")
    if params[:open_card] == "true"
      redirect_to more_options_settings_path("User",user, :open_card => true)
    else
      redirect_to_edit(user, 'login')
    end
  end
end
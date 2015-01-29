module WebHookCallbacks
  extend ActiveSupport::Concern

  # Capture Callback
  included do
    after_create :notify_after_create
    after_update :notify_after_update
    after_destroy :notify_after_destroy
  end

  # Get Callback Type
  # If it match a existing one, Add to notification stack
  def notify_after_create
    NotifyJob.perform_later('create', self) if web_hook_actions.include? :create
  end

  def notify_after_update
    NotifyJob.perform_later('update', self) if web_hook_actions.include? :update
  end

  def notify_after_destroy
    NotifyJob.perform_later('destroy', self) if web_hook_actions.include? :destroy
  end

  # def after_transition(object, transition)
  #   byebug
  # end

  # Get the host url to generate the api url
  def host_url
    Rails.application.routes.default_url_options[:host] || Spree::Store.current.url
  end

  def web_hook_url; raise 'method missing'; end
  def web_hook_actions; raise 'method missing'; end
end
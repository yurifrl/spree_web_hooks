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
    Spree::WebHooks::Hook.create_notifications('create', self)
  end

  def notify_after_update
    Spree::WebHooks::Hook.create_notifications('update', self)
  end

  def notify_after_destroy
    Spree::WebHooks::Hook.create_notifications('destroy', self)
  end

  # Get the host url to generate the api url
  def host_url
    Rails.application.routes.default_url_options[:host] || Spree::Store.current.url
  end

  def web_hook_json#_formated_object
    # Render habl json if send data
    # Send url of the current object
    self.to_json
  end

  def web_hook_url; raise 'method web_hook_url missing'; end
  def web_hook_actions; raise 'method web_hook_actions missing'; end
end

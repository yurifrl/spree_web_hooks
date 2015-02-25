class NotifyJob < ActiveJob::Base
  queue_as :web_hooks

  def perform(notification, log)
    obj = notification.notifiable
    
    signal = WebHookNotifier.new(notification, log)

    if notification.hook_send_data
      data = obj.web_hook_json
    else
      data = {address: obj.web_hook_url}
    end

    signal.deliver!(data)
  end
end

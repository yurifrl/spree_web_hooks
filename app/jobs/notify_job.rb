class NotifyJob < ActiveJob::Base
  queue_as :web_hooks

  def perform(action, model)
    model_name = model.class.name.split('::').last.underscore
    Spree::WebHooks::Hook.joins(:event).where(spree_web_hooks_events: { name: "#{model_name}_#{action}" }).each do |e|
      e.notify(model)
    end
  end
end
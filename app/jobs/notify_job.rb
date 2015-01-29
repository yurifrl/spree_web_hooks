class NotifyJob < ActiveJob::Base
  queue_as :default

  def self.perform(action, model)
    name = model.class.name.split('::').last.underscore
    Spree::WebHooks::Hook.joins(:event).where(spree_web_hooks_events: { name: "#{name}_#{action}" }).each do |e|
      e.notify(model)
    end
  end
end
module Spree
  module WebHooks
    class Hook < Spree::Base

      self.table_name = :spree_web_hooks_hooks

      validates :max_attempts, length: {maximum: 10}

      belongs_to :event, class_name: Spree::WebHooks::Event

      def self.create_notifications(action, object)
        class_name = object.class.name.split('::').last.underscore
        joins(:event).where(spree_web_hooks_events: { name: "#{class_name}_#{action}" }).each do |hook|
          Spree::WebHooks::Notification.create do |n|
            n.notifiable = object
            n.event = hook.event            
            n.max_attempts = hook.max_attempts
            n.hook_content_type = hook.content_type
            n.hook_address = hook.address
            n.hook_send_data = hook.send_data
            n.hook_secret = hook.secret
          end
        end
      end
    end
  end
end

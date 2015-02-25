module Spree
  module WebHooks
    class Notification < Spree::Base

      self.table_name = :spree_web_hooks_notifications

      has_many :logs, class_name: Spree::WebHooks::Log

      belongs_to :event, class_name: Spree::WebHooks::Event

      belongs_to :notifiable, :polymorphic => true

      after_create :notify

      def notify
        self.update_attributes(attempts: self.attempts + 1)
        # Create Log
        log = logs.create(event_name: self.event.name, http_status: self.status, hook_address: self.hook_address)
        NotifyJob.perform_later(self, log)
      end
    end
  end
end

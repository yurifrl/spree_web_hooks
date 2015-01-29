module Spree
  module WebHooks
    class Hook < Spree::Base

      self.table_name = :spree_web_hooks_hooks

      belongs_to :event, class_name: Spree::WebHooks::Event
      has_one :log, class_name: Spree::WebHooks::Log, dependent: :destroy

      # enum content_type: [['application/json', 1], ['application/x-www-form-urlencoded', 2]]

      def notify(model)
        notifier = WebHookNotifier.new(self)
        # Render habl json if send data
        # Send url of the current object
        if send_data
          send = model.to_json
        else
          send = {address: model.web_hook_url}
        end

        notifier.deliver!(send)
      end
    end
  end
end
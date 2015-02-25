module Spree
  module WebHooks
    class Event < Spree::Base
      self.table_name = :spree_web_hooks_events
    end
  end
end

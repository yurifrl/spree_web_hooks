module Spree
  module WebHooks
    class Log < Spree::Base
      self.table_name = :spree_web_hooks_logs
      belongs_to :hook, class_name: Spree::WebHooks::Hook
    end
  end
end
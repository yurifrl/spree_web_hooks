module Spree
  module WebHooks
    class Log < Spree::Base
      self.table_name = :spree_web_hooks_logs
    end
  end
end
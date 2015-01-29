module Spree
  Payment.class_eval do
    include WebHookCallbacks

    def web_hook_actions
      [:update, :create, :destroy]
    end

    def web_hook_url
      "#{host_url}/api/order/#{id}"
    end
  end
end
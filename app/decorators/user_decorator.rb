module Spree
  User.class_eval do
    include WebHookCallbacks

    def web_hook_actions
      [:update, :create, :destroy]
    end

    def web_hook_url
      "#{host_url}/api/user/#{id}"
    end
  end
end
SpreeProductGroup::Group.class_eval do
  include WebHookCallbacks

  def web_hook_actions
    []
  end

  def web_hook_url
    ""
  end
end
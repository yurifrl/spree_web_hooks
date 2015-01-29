class WebHookNotifier
  include HTTParty

  def initialize(object)
    @hook = object
  end

  #
  def deliver!(data)
    begin
      response = ::Http::Exceptions.wrap_and_check do
        self.class.post(@hook.address, body: JSON.dump(data))
      end
    rescue ::Http::Exceptions::HttpException => e
      code = e.response ? e.response.code : nil
      Spree::WebHooks::Log.create(response: e.message, hook_id: @hook.id, http_status: code)
    rescue Exception => e
      Spree::WebHooks::Log.create(response: e.message, hook_id: @hook.id, http_status: nil)
    end
    response
  end
end
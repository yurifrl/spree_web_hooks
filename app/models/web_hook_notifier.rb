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
      e.response ? e.response.code : nil
      Spree::WebHooks::Log.create do |log|
        log.response = e.message
        log.event_name = @hook.event.name
        log.hook_address = @hook.address
        log.http_status = e.response ? e.response.code : nil
      end
    rescue Exception => e
      Spree::WebHooks::Log.create do |log|
        log.response = e.message
        log.event_name = @hook.event.name
        log.hook_address = @hook.address
        log.http_status = nil
      end
    end
    response
  end
end
class WebHookNotifier
  include HTTParty

  format :json

  def initialize(object)
    @hook = object
  end

  #
  def deliver!(data)
    begin
      response = ::Http::Exceptions.wrap_and_check do
        self.class.post(@hook.address, body: data)
      end
    rescue ::Http::Exceptions::HttpException => e
      Spree::WebHooks::Log.create do |log|
        log.msg = e.response.message
        log.response = e.response.inspect
        log.event_name = @hook.event.name
        log.hook_address = @hook.address
        log.http_status = e.response ? e.response.code : nil
      end
    rescue Exception => e
      Spree::WebHooks::Log.create do |log|
        log.msg = e.response.message
        log.response = e.response.inspect
        log.event_name = @hook.event.name
        log.hook_address = @hook.address
        log.http_status = nil
      end
    end

    Spree::WebHooks::Log.create do |log|
      log.msg = response.message
      log.response = response.inspect
      log.event_name = @hook.event.name
      log.hook_address = @hook.address
      log.http_status = response.response ? response.response.code : nil
    end
  end
end
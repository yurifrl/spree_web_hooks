class WebHookNotifier
  include HTTParty

  format :json

  def initialize(object)
    @hook = object
  end

  def deliver!(data)
    begin
      response = ::Http::Exceptions.wrap_and_check do
        self.class.post(@hook.address, body: data, headers: {'Content-Type' => 'application/json', 'Accept' => 'application/json'})
      end
    rescue ::Http::Exceptions::HttpException => e
      Spree::WebHooks::Log.create do |log|
        log.msg = e.parsed_response || e.message
        log.response = e.inspect
        log.event_name = @hook.event.name
        log.hook_address = @hook.address
        log.http_status = e.response ? e.response.code : nil
      end
    rescue Exception => e
      Spree::WebHooks::Log.create do |log|
        log.msg = e.parsed_response || e.message
        log.response = e.inspect
        log.event_name = @hook.event.name
        log.hook_address = @hook.address
        log.http_status = nil
      end
    else
      Spree::WebHooks::Log.create do |log|
        log.msg = response.parsed_response || response.message
        log.response = response.inspect
        log.event_name = @hook.event.name
        log.hook_address = @hook.address
        log.http_status = response.response ? response.response.code : nil
      end
    end
  end
end
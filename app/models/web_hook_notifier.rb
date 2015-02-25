class WebHookNotifier
  include HTTParty

  format :json

  def initialize(notification, log)
    @notification = notification
    @log = log
  end

  def deliver!(data)
    begin
      response = ::Http::Exceptions.wrap_and_check do
        content_type = @notification.hook_content_type == 2 ? 'application/x-www-form-urlencoded' : 'application/json'
        self.class.post(@notification.hook_address, body: {json: data}, headers: {'Content-Type' => content_type, 'Accept' => content_type})
      end
    rescue ::Http::Exceptions::HttpException => e
      @log.msg = e.parsed_response || e.message
      @log.response = e.inspect
      @log.event_name = @notification.event.name
      @log.hook_address = @notification.hook_address
      @notification.status = @log.http_status = e.response ? e.response.code : nil
    rescue Exception => e
      @log.msg = e.parsed_response || e.message
      @log.response = e.inspect
      @log.event_name = @notification.event.name
      @log.hook_address = @notification.hook_address
      @log.http_status = nil
    else
      @log.msg = response.parsed_response || response.message
      @log.response = response.inspect
      @log.event_name = @notification.event.name
      @log.hook_address = @notification.hook_address
      @notification.status = @log.http_status = response.response ? response.response.code : nil
    end

    @notification.save
    @log.save

    if @notification.status != 200 && @notification.attempts <= @notification.max_attempts
      @notification.notify
    end

    {notification: @notification, log: @log}
  end
end

class Dynect::Response
  attr_reader :headers, :status, :body, :request

  def initialize(options={})
    @status  = options[:status]
    @headers = options[:headers]
    @body    = options[:body]
    @request = options[:request]
  end

  def successful?
    self.status >= 200 && self.status <= 299 || self.status == 304
  end
end

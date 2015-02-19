module Dynect::Collection
  def self.included(klass)
    klass.send(:extend, Dynect::Collection::Attributes)
  end

  module Attributes
    def model_root(model_root)
      @model_root = model_root
    end

    def model_request(model_request)
      @model_request = model_request
    end
  end

  def model_root
    self.class.instance_variable_get(:@model_root)
  end

  def model_request
    self.class.instance_variable_get(:@model_request)
  end

  def get(opts)
    result = connection.send(self.model_request, {'zone' => opts[:zone], 'fqdn' => opts[:fqdn]})

    new(result.body['data'])
  end
end

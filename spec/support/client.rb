module ClientHelper
  def create_client(attributes={})
    merged_attributes = attributes.merge(
      user_name: 'engineyard',
      customer_name: 'someone',
      password: 'password'
    )

#    merged_attributes.merge!(logger: Logger.new(STDOUT)) if ENV['VERBOSE']

    Dynect::Client.new(merged_attributes)
  end
end

RSpec.configure do |config|
  config.include(ClientHelper)
end

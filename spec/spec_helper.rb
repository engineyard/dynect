ENV["MOCK_DYNECT"] ||= "true"

Bundler.require(:test)
require File.expand_path("../../lib/dynect", __FILE__)
Dir[File.expand_path("../{shared,support}/*.rb", __FILE__)].each{|f| require(f)}

Cistern.formatter = Cistern::Formatter::AwesomePrint

if ENV["MOCK_DYNECT"] == "true"
  Dynect::Client.mock!
end

RSpec.configure do |config|
  config.order = :random

  config.before(:each) do
    if Dynect::Client.mocking?
      Dynect::Client.reset!
    end
  end
end

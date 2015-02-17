Bundler.require(:test)
Bundler.require(:darwin) if RUBY_PLATFORM.match(/darwin/)
require File.expand_path("../../lib/dynect", __FILE__)
Dir[File.expand_path("../{shared,support}/*.rb", __FILE__)].each{|f| require(f)}

Cistern.formatter = Cistern::Formatter::AwesomePrint

Dynect::Client.mock!

RSpec.configure do |config|
  config.order = :random

  config.before(:each) do
    Dynect::Client.mocking? ? Dynect::Client.reset! : client.reset!
  end
end

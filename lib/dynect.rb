require 'addressable/uri'
require 'cistern'
require 'json'
require 'faraday'
require 'faraday_middleware'
require 'securerandom'
require 'logger'

require_relative 'dynect/version'
require_relative 'dynect/client'
require_relative 'dynect/collection'
require_relative 'dynect/response'

module Dynect
  DEFAULT_TIMEOUT = 30
end

Cistern.timeout = Dynect::DEFAULT_TIMEOUT

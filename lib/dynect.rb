require_relative 'dynect/version'

require 'cistern'
require 'json'
require 'faraday'
require 'faraday_middleware'
require 'ey/logger'
require 'ey/logger/faraday'

require 'logger'
require 'securerandom'

module Dynect; end

require_relative 'dynect/collection'
require_relative 'dynect/response'
require_relative 'dynect/session'
require_relative 'dynect/client'


Dynect::Client::Real.timeout = 30

# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

require 'rack/cache'

use Rack::Cache,
  :verbose     => true,
  :metastore   => 'file:/tmp/rack-cache/meta',
  :entitystore => 'file:/tmp/rack-cache/body'

run Rails.application

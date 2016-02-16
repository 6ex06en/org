module PrivateMessage
  module Adapter

    REDIS_HOST = "127.0.0.1"
    REDIS_PORT = '6379'

    def connection_params(connection = {})
      host = (connection[:host] || REDIS_HOST).to_s
      port = (connection[:port] || REDIS_PORT).to_i
      {host: host, port: port}
    end

  end
end

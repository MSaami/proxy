module Gateway
  class GatewayFactory
    def self.make_for(message)
      "Gateway::#{message.gateway.to_s.upcase_first}Gateway".constantize.new(message)
    rescue StandardError
      raise HandlerNotFoundError, "There is not handler for #{message.gateway}"
    end
  end
end

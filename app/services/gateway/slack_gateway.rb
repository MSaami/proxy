module Gateway
  class SlackGateway < BaseGateway
    def publish
      # publish message to Salck
      response = { "status" => "200", "message" => "Published to Slack" }
      @message.done_by_result(response)
    rescue ReportableError => e
      @message.failed_by_exception(e.uuid)
    end
  end
end

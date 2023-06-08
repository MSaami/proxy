module Gateway
  class DatevGateway < BaseGateway
    def publish
      # publish message to datev

      response = { "status" => "200", "message" => "Published to datev" }
      @message.done_by_result(response)
    rescue ReportableError => e
      @message.failed_by_exception(e.uuid)
    end
  end
end

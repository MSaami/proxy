module Gateway
  class TeamtectureGateway < BaseGateway
    def publish

      # publish message to TeamTecture

      response = {'status' => '200', 'message' => 'Published to TeamTecture'}
      @message.done_by_result(response)
    rescue ReportableError => e
      @message.failed_by_exception(e.uuid)
    end
  end
end

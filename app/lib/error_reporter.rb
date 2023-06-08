class ErrorReporter
  attr_reader :uuid

  def initialize(exception)
    @exception = exception
    @logger ||= Logger.new("log/error_report.log")

    generate_uuid
  end

  def report
    report_to_file

    @uuid
  end

  private

  def generate_uuid
    @uuid = SecureRandom.uuid
  end

  def report_to_file
    @logger.error("uuid: #{@uuid}, message: #{@exception.message}, exception: #{@exception.class}")
  end
end

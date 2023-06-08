class ReportableError < StandardError
  attr_reader :uuid
  def initialize(msg = '')
    super(msg)
    report_exception
  end

  private
    def report_exception
      @uuid = ErrorReporter.new(exception).report
    end
end

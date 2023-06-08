class Message < ApplicationRecord
  DELAYED_MINUTE = 1
  enum :status, [:processing, :done, :failed], default: :processing
  enum :gateway, [:slack, :teamtecture, :datev]

  has_one_attached :file

  validates :status, inclusion: {in: statuses.keys}
  validates :gateway, inclusion: {in: gateways.keys}
  validates :gateway, presence: true
  validates :file, presence: true
  validates :file, attached: true, content_type: [:csv, :pdf, :jpeg, :png]

  after_create :enqueue_to_publish

  def gateway=(value)
    super
  rescue ArgumentError
    @attributes.write_cast_value("gateway", value)
  end

  def status=(value)
    super
  rescue ArgumentError
    @attributes.write_cast_value("status", value)
  end


  def failed_by_exception(result)
    self.status = 'failed'
    self.result = {'exception_uuid': result}
    self.save
  end

  def done_by_result(result)
    self.status = 'done'
    self.result = {'response': result}
    self.save
  end

  def publish!
    gateway_publisher.publish
  rescue ReportableError => e
    failed_by_exception(e.uuid)
  rescue StandardError => e
    failed_by_exception(ErrorReporter.new(e).report)
  end

  private
  def enqueue_to_publish
    MessageSenderJob.set(wait: DELAYED_MINUTE.minute).perform_later id
  end

  def gateway_publisher
    Gateway::GatewayFactory.make_for self
  end

end

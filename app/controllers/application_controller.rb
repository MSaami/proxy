class ApplicationController < ActionController::API
  rescue_from HandlerNotFoundError, with: :respond_with_error
  rescue_from ActiveRecord::RecordInvalid, with: :respond_with_validation

  def respond_with_validation(e)
    render json: {errors: e.record.errors.messages}, status: 422
  end

end

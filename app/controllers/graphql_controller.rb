class GraphqlController < Api::BaseController
  before_action :authenticate_with_service_key

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      # Query context goes here, for example:
      current_user: current_user,
    }
    result = BaseSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue AuthorizationError => e
    handle_authorization_error(e)
  rescue StandardError => e
    if Rails.env.development?
      handle_error_in_development(e)
    else
      handle_error(e)
    end
  end

  private

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500
  end

  def handle_authorization_error(e)
    render json: { errors: [{ message: e.message, extensions: { path: '$', code: 'authorization-error' } }], data: {} }, status: 403
  end

  def handle_error(e)
    render json: { errors: [{ message: e.message, extensions: { path: '$', code: 'unexpected-error' } }], data: {} }, status: 500
  end
end

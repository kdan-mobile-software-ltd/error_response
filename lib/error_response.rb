require 'settingslogic'
class ErrorResponse < Settingslogic
  source "lib/error_response.yml"

  def call(key, message=nil)
    error_data = send(key)

    if error_data.present?
      status = error_data['error_code'][0..2]
      {
        status: status,
        json: error_data
      }
    else
      {
        status: 500,
        json: {
          error_code: 50000,
          error_message: message
        }
      }
    end
  end
end
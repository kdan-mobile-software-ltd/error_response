require 'settingslogic'
class ErrorResponse < Settingslogic
  source "lib/error_code.yml"

  def api_format(key)
    error_data = send(key)
    status = fetch_status(error_data['error_code'])
    {
      status: status,
      json: error_data
    }
  end
  
  private
  def fetch_status(error_code)
    return error_code if error_code == 500
    error_code[0..2]
  end
end
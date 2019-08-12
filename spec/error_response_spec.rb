require './lib/error_response'

RSpec.describe ErrorResponse do
  describe '#call' do
    it "should return correspond hash when key existed" do
      hash = {
        'status' => 400,
        'json' => {
          'error_code' => 400002,
          'error_message' => 'user password not correct'
        }
      }
      error = ErrorResponse.call(:wrong_password)
      expect(error).to eq hash
    end

    it "should return personalized hash when key not existed" do
      hash = {
        'status' => 500,
        'json' => {
          'error_code' => 500000,
          'error_message' => 'something went wrong'
        }
      }
      error = ErrorResponse.call(:internal_error, 'something went wrong')
      expect(error).to eq hash
    end
  end
end
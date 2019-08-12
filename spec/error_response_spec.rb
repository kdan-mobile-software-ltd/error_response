require './lib/error_response'

RSpec.describe ErrorResponse do
  describe '#to_api' do
    it "should return correspond hash when key existed" do
      hash = {
        'status' => 400,
        'json' => {
          'error_code' => 400002,
          'error_message' => 'user password not correct'
        }
      }
      result = ErrorResponse.to_api(:wrong_password)
      expect(result).to eq hash
    end

    it "should return personalized hash when key not existed" do
      hash = {
        'status' => 500,
        'json' => {
          'error_code' => 500000,
          'error_message' => 'something went wrong'
        }
      }
      result = ErrorResponse.to_api(:internal_error, 'something went wrong')
      expect(result).to eq hash
    end
  end

  describe '#to_hash' do
    it "should return hash when key existed" do
      hash = {
        'error_code' => 400002,
        'error_message' => 'user password not correct'
      }
      result = ErrorResponse.to_hash(:wrong_password)
      expect(result).to eq hash
    end

    it "should return nil when key not existed" do
      result = ErrorResponse.to_hash(:some_error)
      expect(result).to eq nil
    end
  end
end
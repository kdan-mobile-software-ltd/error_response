require './lib/error_response'

RSpec.describe ErrorResponse do
  describe '#yaml_hash' do
    it 'should fetch data from local' do
      result = ErrorResponse.to_api(:resource_not_found)
      expect(result[:json]['error_message']).to eq 'resource not found'
      expect(result[:json]['error_code']).to eq 404_001
    end

    it 'should fetch data from remote' do
      result = ErrorResponse.to_api(:bad_request_2)
      expect(result[:json]['error_message']).to eq 'bad request 2'
      expect(result[:json]['error_code']).to eq 400_002
    end
  end

  describe '#to_api' do
    it "should return correspond hash when key existed" do
      hash = {
        status: 400,
        json: {
          'error_code' => 400_001,
          'error_message' => 'bad request 1',
          'error_key' => 'bad_request_1'
        }
      }
      result = ErrorResponse.to_api(:bad_request_1)
      expect(result).to eq hash
    end

    it "should return personalized hash when key not existed" do
      hash = {
        status: 500,
        json: {
          'error_code' => 500_000,
          'error_message' => 'internal_error: something went wrong',
          'error_key' => 'internal_error'
        }
      }
      result = ErrorResponse.to_api(:internal_error, 'something went wrong')
      expect(result).to eq hash
    end
  end

  describe '#to_hash' do
    it "should return hash when key existed" do
      hash = {
        'error_code' => 400_001,
        'error_message' => 'bad request 1',
        'error_key' => 'bad_request_1'
      }
      result = ErrorResponse.to_hash(:bad_request_1)
      expect(result).to eq hash
    end

    it "should return {} when key not existed" do
      result = ErrorResponse.to_hash(:some_error)
      empty_hash = {}
      expect(result).to eq empty_hash
    end
  end
end

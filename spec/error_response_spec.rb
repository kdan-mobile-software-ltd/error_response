require './lib/error_response'

RSpec.describe ErrorResponse do
  describe '#to_api' do
    it "should return correspond hash when key existed" do
      hash = {
        status: 418,
        json: {
          'error_code' => 418_003,
          'error_message' => 'happy tree friend',
          'error_key' => 'happy_tree_friend'
        }
      }
      result = ErrorResponse.to_api(:happy_tree_friend)
      expect(result).to eq hash
    end

    it "should return personalized hash when key not existed" do
      hash = {
        status: 500,
        json: {
          'error_code' => 500_000,
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
        'error_code' => 418_003,
        'error_message' => 'happy tree friend',
        'error_key' => 'happy_tree_friend'
      }
      result = ErrorResponse.to_hash(:happy_tree_friend)
      expect(result).to eq hash
    end

    it "should return nil when key not existed" do
      result = ErrorResponse.to_hash(:some_error)
      expect(result).to eq nil
    end
  end
end

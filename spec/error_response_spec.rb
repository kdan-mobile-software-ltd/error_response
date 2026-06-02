# frozen_string_literal: true

require "./lib/error_response"

RSpec.describe ErrorResponse do
  after do
    ErrorResponse.configure do |config|
      config.error_message_resolver = nil
    end
  end

  describe "#yaml_hash" do
    it "should fetch data from local" do
      result = ErrorResponse.to_api(:resource_not_found)
      expect(result[:json]["error_message"]).to eq "resource not found"
      expect(result[:json]["error_code"]).to eq 404_001
    end

    it "should fetch data from remote" do
      result = ErrorResponse.to_api(:bad_request_2)
      expect(result[:json]["error_message"]).to eq "bad request 2"
      expect(result[:json]["error_code"]).to eq 400_002
    end
  end

  describe "#to_api" do
    it "should return correspond hash when key existed" do
      hash = {
        status: 400,
        json: {
          "error_code" => 400_001,
          "error_message" => "bad request 1",
          "error_key" => "bad_request_1"
        }
      }
      result = ErrorResponse.to_api(:bad_request_1)
      expect(result).to eq hash
    end

    it "should return personalized hash when key not existed" do
      hash = {
        status: 500,
        json: {
          "error_code" => 500_000,
          "error_message" => "internal_error: something went wrong",
          "error_key" => "internal_error"
        }
      }
      result = ErrorResponse.to_api(:internal_error, "something went wrong")
      expect(result).to eq hash
    end
  end

  describe "#to_hash" do
    it "should return hash when key existed" do
      hash = {
        "error_code" => 400_001,
        "error_message" => "bad request 1",
        "error_key" => "bad_request_1"
      }
      result = ErrorResponse.to_hash(:bad_request_1)
      expect(result).to eq hash
    end

    it "should return hash when key existed in remote source" do
      hash = {
        "error_code" => 400_002,
        "error_message" => "bad request 2",
        "error_key" => "bad_request_2"
      }
      result = ErrorResponse.to_hash(:bad_request_2)
      expect(result).to eq hash
    end

    it "should return {} when key not existed" do
      result = ErrorResponse.to_hash(:some_error)
      empty_hash = {}
      expect(result).to eq empty_hash
    end
  end

  describe "#resolve_error_message" do
    it "returns original message when resolver is not configured" do
      result = ErrorResponse.resolve_error_message(
        key: :bad_request_1,
        error_message: "original message",
        error_data: {}
      )
      expect(result).to eq "original message"
    end

    it "supports keyword style resolver" do
      ErrorResponse.configure do |config|
        config.error_message_resolver = lambda do |key:, error_message:, error_data:, context:|
          "#{key}|#{error_message}|#{error_data[:foo]}|#{context.nil?}"
        end
      end

      result = ErrorResponse.resolve_error_message(
        key: :bad_request_1,
        error_message: "original message",
        error_data: { foo: "bar" }
      )
      expect(result).to eq "bad_request_1|original message|bar|true"
    end

    it "supports positional style resolver for backward compatibility" do
      ErrorResponse.configure do |config|
        config.error_message_resolver = lambda do |key, error_message, error_data, context|
          "#{key}|#{error_message}|#{error_data[:foo]}|#{context.nil?}"
        end
      end

      result = ErrorResponse.resolve_error_message(
        key: :bad_request_1,
        error_message: "original message",
        error_data: { foo: "bar" }
      )
      expect(result).to eq "bad_request_1|original message|bar|true"
    end

    it "falls back to original message when resolver raises exception" do
      ErrorResponse.configure do |config|
        config.error_message_resolver = lambda do |_key:, _error_message:, _error_data:, _context:|
          raise "resolver error"
        end
      end

      result = ErrorResponse.resolve_error_message(
        key: :bad_request_1,
        error_message: "original message",
        error_data: {}
      )
      expect(result).to eq "original message"
    end
  end
end

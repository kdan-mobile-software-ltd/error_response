# Error Response

`Error Response` is a json response gem to help you easily manage all your custom error statuses in your Rails application.

## Installation

Add `error_response` to your Rails application's `Gemfile`.

```ruby
gem 'error_response'
```

And then install the gem.

```bash
$ bundle install
```

## Configuration

Create your response config in `config/error_response.yml`.

```yaml
# config/error_response.yml

source:
  local:
    - your/local/file_1.yml
    - your/local/file_2.yml
  remote:
    - https://your_remote_file_1.yml
    - https://your_remote_file_2.yml
```

The `error_response` gem looks up all `yml` files and merge them into a hash.

You can also customize your config file path through configuration.

```ruby
ErrorResponse.configure do |config|
  config.yaml_config_path = 'your/local/config/file.yml'
end
```


## Usage

Include helpers in your base application controller.
```ruby
# in controller
class Api::ApplicationController < ActionController::Base
  include ErrorResponse::Helper

  ...
end
```

### Success Response

The success response is used when the request is success.

```ruby
# in controller actions
data = { a: 1, b: 2 }
return success_response(data) if success?
```

```json
// response status: 200
// response body:
{
  "data": {
    "a": 1,
    "b": 2
  }
}
```

### Error Response

The error response is used when the request is not valid. Therefore, you need to provide the `error_key` defined in the config files.

```ruby
# in controller actions
return error_response(:bad_request_1) if failed?
```

```json
// response status: 400
// response body:
{
  "error_code": 400_001,
  "error_message": "bad request 1",
  "error_key": "bad_request_1"
}
```

You can also provide your custom error message and error data. If error data is a hash, it will be merged into the json response; If it is an array, it will be merged into the json response with an `error_data` key.

```ruby
# in controller actions
return error_response(:bad_request_1, 'no required data', { a: 1, b: 2 }) if failed?
```

```json
// response status: 400
// response body:
{
  "error_code": 400_001,
  "error_message": "bad request 1: no required data",
  "error_key": "bad_request_1",
  "a": 1,
  "b": 2
}
```


### RequestError Exception
If you do not want to handle the response in controllers, you can just raise an `ErrorResponse::RequestError` exception. The gem will catach the exception in the base application controller and render an error_response.

```ruby
# in any business logic file
raise ErrorResponse::RequestError.new(:bad_request_1)
```


## Others

See all available error_code & error_message

```ruby
ErrorResponse.all
```

Return to hash only

```ruby
ErrorResponse.to_hash(:bad_request_1)
```

gives you

```json
// response status: 400
// response body: 
{
  "error_code": 400_001,
  "error_message": "bad request 1",
  "error_key": "bad_request_1"
}
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

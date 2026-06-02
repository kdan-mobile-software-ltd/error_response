# Error Response

[![Gem Version](https://badge.fury.io/rb/error_response.svg?icon=si%3Arubygems)](https://badge.fury.io/rb/error_response)

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

### Error Message Resolver

You can provide an extension hook to customize the message passed into `ErrorResponse::Helper#error_response` without monkey patching.

When `error_response` is called, the gem invokes `ErrorResponse.resolve_error_message` before building the API payload. The resolved value is then passed to `ErrorResponse.to_api` as the optional message suffix.

```ruby
ErrorResponse.configure do |config|
  config.error_message_resolver = lambda do |key:, error_message:, error_data:, context:|
    # Return a string message, nil, or any value accepted by `to_api`.
    # context is the current controller instance when called from helper.
    "customized message for #{key}"
  end
end
```

#### Resolver arguments

| Argument | Description |
| --- | --- |
| `key` | The error key passed to `error_response` (e.g. `:bad_request_1`). |
| `error_message` | The optional custom message passed to `error_response`. |
| `error_data` | The optional hash or array passed to `error_response`. |
| `context` | The current controller instance when called from `ErrorResponse::Helper`. `nil` when calling `ErrorResponse.resolve_error_message` directly. |

#### Return value

- Return a `String` to append after the YAML-defined message (e.g. `"bad request 1: customized message for bad_request_1"`).
- Return `nil` to keep only the YAML-defined message (no suffix is appended).
- If the resolver is not configured, does not respond to `call`, or raises an exception, the original `error_message` is used as a safe fallback.

#### Supported resolver signatures

Keyword arguments (recommended):

```ruby
config.error_message_resolver = lambda do |key:, error_message:, error_data:, context:|
  error_message
end
```

Positional arguments (backward compatible):

```ruby
config.error_message_resolver = lambda do |key, error_message, error_data, context|
  error_message
end
```

`**kwargs` style:

```ruby
config.error_message_resolver = lambda do |**kwargs|
  kwargs[:error_message]
end
```

Method object:

```ruby
class ErrorMessageResolver
  def call(key:, error_message:, error_data:, context:)
    error_message
  end
end

ErrorResponse.configure do |config|
  config.error_message_resolver = ErrorMessageResolver.new
end
```

#### Example with `error_response`

Given this resolver:

```ruby
ErrorResponse.configure do |config|
  config.error_message_resolver = lambda do |key:, error_message:, error_data:, context:|
    I18n.t("errors.#{key}", default: error_message, **error_data)
  end
end
```

Calling `error_response(:bad_request_1, 'no required data', { a: 1 })` produces:

```json
{
  "error_code": 400001,
  "error_message": "bad request 1: no required data",
  "error_key": "bad_request_1",
  "a": 1
}
```

The resolver can rewrite `error_message` before it is appended. `error_data` is merged into the JSON response after message resolution and is not modified by the resolver.


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

The success response is used when the request is success. The response body is a hash with a `data` key.

```ruby
# in controller actions
data = { a: 1, b: 2 }
return success_response(data) if success?
```

> response status: 200
> 
> response body:

```json
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

> response status: 400
> 
> response body:

```json
{
  "error_code": 400001,
  "error_message": "bad request 1",
  "error_key": "bad_request_1"
}
```

You can also provide your custom error message and error data. If error data is a hash, it will be merged into the json response; If it is an array, it will be merged into the json response with an `error_data` key.

When `config.error_message_resolver` is configured, the custom message is passed through the resolver before being appended to the YAML-defined message. See [Error Message Resolver](#error-message-resolver) for details.

```ruby
# in controller actions
return error_response(:bad_request_1, 'no required data', { a: 1, b: 2 }) if failed?
```

> response status: 400
> 
> response body:

```json
{
  "error_code": 400001,
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
{
  "error_code": 400001,
  "error_message": "bad request 1",
  "error_key": "bad_request_1"
}
```

Resolve error message with optional resolver hook

```ruby
ErrorResponse.resolve_error_message(
  key: :bad_request_1,
  error_message: "no required data",
  error_data: { field: "email" },
  context: controller # optional
)
```

gives you the resolved message string (or the original `error_message` when no resolver is configured), for example:

```
"no required data"
```

## Security

If you would like to report a security issue, please review the [Security Policy](SECURITY.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

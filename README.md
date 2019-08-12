# Error Response

### Installation

```
gem 'error_response'
```

### Use it perfectly with error_response

define a error_response method in Api::ApplicationController

```
def error_response(key)
  render ErrorResponse.to_api(key)
end
```

simeply use it where you want

```
return error_reponse(:wrong_email) if @user.nil
```

the response will look like this

```
{
  status: 403,
  json:
    {
      error_code: 403004,
      error_message: 'third-party provider is not allow'
    }
}
```

### Others

See all avaliable error_code & error_message

`ErorrResponse.all`

Return to hash only

`ErrorResponse.to_hash(:reset_password_failed)`

gives you

```
{
  error_code: 400005,
  error_message: 'reset password failed'
}
```

### Update

Update the error_code.yml if you want new error_code

Send Pull Request after update
# Error Response

### Installation

```
gem 'error_response'
```

### Use it perfectly with error_response

define a error_response method in Api::ApplicationController

```
  def error_response(error_key, error_message=nil)
    render ErrorResponse.to_api(error_key, error_message)
  end
```

simeply use it where you want

```
return error_reponse(:happy_tree_friend_key) if @user.nil
```

the response will look like this

```
{
  status: 418,
  json:
    {
      error_code: 418003,
      error_message: 'happy tree friend',
      error_key: 'happy_tree_friend_key'
    }
}
```

### Prepare

Before you start it, you should create `config/error_response.yml` and put the errors into it.

the yml must follow the same style otherwise error may happend.

```
// config/error_response.yml

my_own_error:
  error_code: 418_005
  error_message: this is my own error

```

Or import it from url

```
ErrorResponse.load_remote(url_path)
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
  error_message: 'reset password failed',
  error_key: 'reset_password_failed'
}
```
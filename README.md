# Error Response

### Getting started

```
gem 'error_response'
```

Run `bundle install`

create  `config/error_response.yml`

```
# config/error_response.yml

source:
  local:
    - ENV['YOUR_LOCAL_FILE_PATH']
  remote:
    - https://your_remote_file.yml
```

define a error_response method in Api::ApplicationController

```
  #  app/controller/api/v1/application_controller.rb

  def error_response(error_key, error_message=nil)
    render_content = ErrorResponse.to_api(error_key, error_message).deep_dup
    render_content[:json].delete('app_code')
    render(render_content)
  end
```


### Ready to Go
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

### Others

See all avaliable error_code & error_message

`ErrorResponse.all`

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

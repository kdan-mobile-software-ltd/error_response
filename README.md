# Error Response

### Getting started

```
gem 'error_response'
```

Then run `bundle install`

Next, choose the place you want to store your error_response.

1. Save locally. Create `config/error_response.yml` and put the errors into it.

```
// config/error_response.yml

my_own_error:
  error_code: 418_005
  error_message: this is my own error

```
2. Use remote url. Create `config/initializers/error_response.rb` and load the errors there.

```
url_path = ENV['YOUR_PATH']
ErrorResponse.load_remote(url_path)
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
### Error Code Map

|      Server      | Error Code |
|:----------------:|:----------:|
| signature_center |   xxx_0xx  |
|   store_center   |   xxx_1xx  |
|   member_center  |   xxx_2xx  |
|  receipt_center  |   xxx_3xx  |
|    data_center   |   xxx_4xx  |
|       apns       |   xxx_5xx  |
|     anizone      |   xxx_6xx  |
|    cr_system     |   xxx_7xx  |
|   mail_center    |   xxx_8xx  |
| signature_center |   xxx_9xx  |
|    note_center   |   xxx_10xx |
|  convert_center  |   xxx_11xx |
|  control_center  |   xxx_12xx |

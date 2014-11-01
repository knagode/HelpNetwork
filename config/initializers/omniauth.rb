Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Rails.configuration.omniauth.facebook.id, Rails.configuration.omniauth.facebook.secret
  provider :google_oauth2, Rails.configuration.omniauth.google.id, Rails.configuration.omniauth.google.secret
end
if !Rails.env.production?

  OmniAuth.config.test_mode = true


  OmniAuth.config.add_mock(:facebook, {
    "uid"       => '1234501',
     "info" => {
        "email" => "john.doe.test@my_nice_domain.io",
        "first_name" => "John",
        "last_name"  => "Doe",
        "name"       => "John Doe"
        # any other attributes you want to stub out for testing
     }
    })

end

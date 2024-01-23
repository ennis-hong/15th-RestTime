Geocoder.configure(
  lookup: :google,
  use_https: true,
  api_key: Rails.application.credentials.dig(:google, :geolocation_api_key)
)
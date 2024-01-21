Geocoder.configure(
  lookup: :google,
  use_https: true,
  api_key: ENV['GOOGLE_GEOLOCATION_API_KEY']
)
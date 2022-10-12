class BeermappingApi
  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city) { get_places_in(city) }
  end

  def self.get_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) && places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do |place|
      Place.new(place)
    end
  end

  def self.specific_place(place_id)
    Rails.cache.fetch(id) { get_specific_place(place_id) }
  end

  def self.get_specific_place(place_id)
    url = "http://beermapping.com/webservice/locquery/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(place_id)}" # sanitize just in case
    place = response.parsed_response["bmp_locations"]["location"]

    return nil if place.is_a?(Hash) && place['id'] == '0'

    Place.new(place)
  end

  def self.key
    return nil if Rails.env.test?
    raise 'BEERMAPPING_APIKEY env variable not defined' if ENV['BEERMAPPING_APIKEY'].nil?

    ENV.fetch('BEERMAPPING_APIKEY')
  end
end

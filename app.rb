require 'sinatra'
require 'json'
require 'factbook'
require 'redis'
require 'logger'

logger = Logger.new(STDOUT)
logger.level = Logger::INFO

# connect to the local Redis instance
@@redis = Redis.new

countries_index = {}

# executed only once, at startup
configure do

  # build a quick index country_code => country_name
  Factbook.codes.each do |code|
    countries_index[code.code] = code.name
  end

  logger.info("Index created, ready to handle requests")
end

# executed before processing any http request
before do
  # Set the response headers
  cache_control :public, :must_revalidate, :max_age => 86400
  content_type 'application/json'
end

after do
  # pretty print the JSON response
  if response.body[0] != nil
    response.body[0] = JSON.pretty_generate(JSON.load(response.body[0]))
  end
end

# return the list of countries codes
get '/factbook/codes' do
  Factbook.codes.to_json
end

# return the list of supported attributes
get '/factbook/attributes' do
  File.read("data/attributes.json")
end

get '/factbook/:code' do

  code = params['code']

  # validate that the country code exists
  if not countries_index.key?(code)
    halt 404 # return 404 not found
  end

  factbook_page = fetch_factbook_page(code)

  # create the response
  response = { 'country-code' => code, 'country-name' => countries_index[code] }
  response['data'] = factbook_page
  JSON.generate(response)
end

get '/factbook/:code/:attribute' do

  code = params['code']
  attribute = params['attribute']

  # validate that the country code exists
  if not countries_index.key?(code)
    halt 404 # return 404 not found
  end

  factbook_page = fetch_factbook_page(code)

  # validate that the attribute exists
  attribute_function = attribute.gsub("-","_")
  if !factbook_page.respond_to? attribute_function
    halt 404 # return 404 not found
  end

  # get the data for this specific attribute
  text = factbook_page.public_send(attribute_function).to_s

  # create the response
  response = { 'country-code' => code, 'country-name' => countries_index[code] }
  response[attribute] = { 'text' => text, 'numbers' => extract_numbers(text)}
  JSON.generate(response)
end

# fetches data from the CIA World Factbook for a specific country
#
# it seems the website is updated weekly, so once fetched the page will
# be saved in Redis with an expiration of
#
def fetch_factbook_page(country_code)
  logger.info("Fetching data for country code : #{country_code}")

  key = "factbook.#{country_code}"
  cached_data = @@redis.get(key)

  if cached_data != nil
    logger.info("Found data in the cache")
    page = Marshal.load(cached_data)
    return page
  else
    logger.info("No data in the cache, connecting to the CIA World Factbook...")
    page = Factbook::Page.new(country_code)
    page_json = Marshal.dump(page)
    one_week = 604800
    logger.info("Saving the data in the cache")
    @@redis.setex(key, one_week, page_json)
    return page
  end

end

# extracts numbers from a string and return them as an array
# ex : "7,491 km" => [7491.0]
# ex : "0.75% (2016 est.)" => [0.75, 2016.0]
#
def extract_numbers(string)
  results = []
  numbers = string.scan(/(\d+[.?,?\d*]*\s?)/i)

  if numbers != nil
    numbers.each do |number|
      puts number[0]
      formatted_number = number[0].gsub(",", "")
      final_number = formatted_number.gsub(" ", "").to_f
      results << final_number
    end
  end

  results
end

require 'sinatra'
require 'json'
require 'factbook'
require 'redis'
#require 'pry'

codes_index = {}

# Executed only once, at startup
configure do

  # build a quick index country_code => country_name
  Factbook.codes.each do |code|
    codes_index[code.code] = code.name
  end
end

# Before processing every http request
before do
  # Set the response headers
  cache_control :no_cache
  content_type 'application/json'
end

after do
  # pretty print the JSON response
  if response.body[0] != nil
    response.body[0] = JSON.pretty_generate(JSON.load(response.body[0]))
  end
end

# return the list of countries codes
get '/codes' do
  Factbook.codes.to_json
end

# return the list of supported attributes
get '/attributes' do
  File.read("data/attributes.json")
end

get '/:code' do
  code = params['code']

  page = Factbook::Page.new(code)

  response = {}
  response['country-code'] = code
  response['country-name'] = codes_index[code]
  response['data'] = page
  JSON.generate(response)
end

get '/:code/:attribute' do

  code = params['code']
  attribute = params['attribute']

  method_attribute = attribute.gsub("-","_")

  page = Factbook::Page.new(code)

  if !page.respond_to? method_attribute
    halt 404 # return 404 not found
  end

  data = page.public_send(method_attribute)
  text = data.to_s

  response = {}
  response['country-code'] = code
  response['country-name'] = codes_index[code]
  response[attribute] = {}
  response[attribute]['text'] = text

  numbers = text.scan(/(\d+[.?,?\d*]*\s?)/i)

  if numbers != nil
   response[attribute]['numbers'] = []

    numbers.each do |number|
      puts number[0]
      formatted_number = number[0].gsub(",", "")
      final_number = formatted_number.gsub(" ", "").to_f
      response[attribute]['numbers'] << final_number
    end

  end

  JSON.generate(response)
end

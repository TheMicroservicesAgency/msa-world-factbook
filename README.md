
# msa-world-factbook

Semi structured API for the CIA World Factbook, a reference of information for 267 countries.

Built with the [factbook](https://github.com/factbook/factbook) ruby gem.

## Quick start

Execute the microservice container with the following command :

    docker run -ti -p 9904:80 msagency/msa-world-factbook

## Example(s)

To get the list of countries :

    $ curl http://localhost:9904/factbook/codes
    {
      "codes": [
        {
          "code": "af",
          "name": "Afghanistan",
          "category": "Countries",
          "region": "South Asia"
        },
        {
          "code": "al",
          "name": "Albania",
          "category": "Countries",
          "region": "Europe"
        },
        ...

To get the list of attributes :

    $ curl http://localhost:9904/factbook/attributes
    {
      "background": "Background",
      "location": "Location",
      "coords": "Geographic coordinates",
      "map": "Map references",
      "area": "Area › total",
      "area-land": "Area › land",
      "area-water": "Area › water",
      "area-note": "Area › note",
       ...


All the data is in text format, but the app will try to extract the numbers from the text for convenience :

    $ curl http://localhost:9904/factbook/br/area
    {
      "country-code": "br",
      "country-name": "Brazil",
      "area": {
        "text": "8,515,770 sq km",
        "numbers": [
          8515770.0
        ]
      }

    $ curl http://localhost:9904/factbook/us/area
    {
      "country-code": "us",
      "country-name": "United States",
      "area": {
        "text": "9,833,517 sq km",
        "numbers": [
          9833517.0
        ]
      }

Without a specific attribute, a summary of all the data for this country will be returned :

    $ curl http://localhost:9904/factbook/br
    {
      "country-code": "br",
      "country-name": "Brazil",
      "data": {
        "Introduction": {
          "Background": {
            "text": "Following more than three centuries under Portuguese rule, Brazil gained its independence in ..."
          }
        },
        "Geography": {
          "Location": {
            "text": "Eastern South America, bordering the Atlantic Ocean"
          },
          "Geographic coordinates": {
            "text": "10 00 S, 55 00 W"
          },
          "Map references": {
            "text": "South America"
          },
          ...

## Endpoints

- GET [/factbook/codes](/factbook/codes) : Returns the list of country codes
- GET [/factbook/attributes](/factbook/attributes) : Returns the list of country attributes
- GET [/factbook/:code](/factbook/br) : Returns a summary of all the data for a given country
- GET [/factbook/:code/:attribute](/factbook/br/taxes) : Returns the data for the specified attribute for a given country

## Standard endpoints

- GET [/ms/version](/ms/version) : returns the version number
- GET [/ms/name](/ms/name) : returns the name
- GET [/ms/readme.md](/ms/readme.md) : returns the readme (this file)
- GET [/ms/readme.html](/ms/readme.html) : returns the readme as html
- GET [/swagger/swagger.json](/swagger/swagger.json) : returns the swagger api documentation
- GET [/swagger/#/](/swagger/#/) : returns swagger-ui displaying the api documentation
- GET [/nginx/stats.json](/nginx/stats.json) : returns stats about Nginx
- GET [/nginx/stats.html](/nginx/stats.html) : returns a dashboard displaying the stats from Nginx

## About

A project by the [Microservices Agency](http://microservices.agency).

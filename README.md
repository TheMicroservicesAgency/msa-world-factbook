
# msa-world-factbook

Semi structured API for the CIA World Factbook, a reference of information for 267 countries.

Built with the [factbook](https://github.com/factbook/factbook) ruby gem.

## Quick start

Execute the microservice container with the following command :

    docker run -ti -p 9904:80 msagency/msa-world-factbook

## Endpoints



## Standard endpoints

- [/ms/version](/ms/version) : returns the version number
- [/ms/name](/ms/name) : returns the name
- [/ms/readme.md](/ms/readme.md) : returns the readme (this file)
- [/ms/readme.html](/ms/readme.html) : returns the readme as html
- [/swagger/swagger.json](/swagger/swagger.json) : returns the swagger api documentation
- [/swagger/#/](/swagger/#/) : returns swagger-ui displaying the api documentation
- [/nginx/stats.json](/nginx/stats.json) : returns stats about Nginx
- [/nginx/stats.html](/nginx/stats.html) : returns a dashboard displaying the stats from Nginx

## About

A project by the [Microservices Agency](http://microservices.agency).

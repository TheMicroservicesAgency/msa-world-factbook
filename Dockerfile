FROM msagency/msa-image-ruby:1.0.2

# Install Redis
RUN apk add --update redis

# Install the Ruby dependencies
RUN apk add --update build-base libxml2-dev libxslt-dev
ADD Gemfile /opt/ms/
RUN cd /opt/ms/ \
 && gem install bundler \
 && bundle config build.nokogiri --use-system-libraries \
 && bundle

# Override the default endpoints
ADD README.md NAME LICENSE VERSION /opt/ms/
ADD swagger.json /opt/swagger/swagger.json

# Copy all the other application files to /opt/app
ADD run.sh /opt/ms/
ADD app.rb /opt/ms/
ADD data /opt/ms/data

# Execute the run script
CMD ["ash", "/opt/ms/run.sh"]

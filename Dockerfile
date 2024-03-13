# Use an official Ruby image as a parent image
FROM ruby:3.1

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs ruby-vips libvips-dev

# Add Yarn repository and install Yarn
# Note: The installation commands might change based on the version of the OS the Ruby image uses
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update && apt-get install -y yarn

# Set the working directory inside the container
WORKDIR /photastic2

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile /photastic2/Gemfile
COPY Gemfile.lock /photastic2/Gemfile.lock

# Install any needed gems
RUN bundle install

# Copy the current directory contents into the container
COPY . /photastic2

# Add a script to be executed every time the container starts
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process
CMD ["rails", "server", "-b", "0.0.0.0"]

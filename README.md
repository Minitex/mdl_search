# MDL Search

An implementation of the [Blacklight Search](http://projectblacklight.org/) platform.

# Developer Quickstart

## Local/Docker hybrid

We'll run the Rails app locally, but the databases (MySQL, Redis, and Solr) are containerized.

Install [Docker](https://docs.docker.com/engine/install/) and Docker Compose
Install [Docker Compose](https://docs.docker.com/compose/)

Copy the .env-example file

```bash
cp .env-example .env
```

Once this file has been copied, you will need to legitimize the values of the various environment variables it contains. Check with Paul Swanson to get real values for variables that have placeholders.

Install Ruby 3.1.2 via [rbenv](https://github.com/rbenv/rbenv)

```bash
brew install rbenv ruby-build
rbenv init
rbenv install 3.1.2
```

Install MySQL and Redis clients, as well as geckodriver for system tests run via Selenium.

```bash
brew install mysql@5.7 redis geckodriver tesseract
```

Install Nginx and mkcert (for local SSL)

```bash
brew install nginx
brew install mkcert
brew install nss # If you use Firefox
```

Install a local SSL cert

```bash
mkcert -install # Will ask for sudo password

mkcert mdl.devlocal

mkdir -p certs
mv mdl.devlocal* ./certs/
```

Install the Nginx config

```bash
./bin/install_nginx_conf
```

Start Nginx

```bash
sudo brew services start nginx
```

Install Node via [NVM](https://github.com/nvm-sh/nvm) (or preferred alternative)

```bash
nvm install 20
```

Install Yarn

```bash
npm i -g yarn
```

Run the setup script (builds Docker images for dependencies)

```bash
./local-dev-init.sh
```

Start Sidekiq

```bash
./start_sidekiq.sh 'default -q iiif_search -q critical,2'
```

Ingest some content

```bash
INGEST_ALL=1 bundle exec rake 'mdl_ingester:collection[p15160coll13]'
INGEST_ALL=1 bundle exec rake 'mdl_ingester:collection[p16022coll10]'
```

## Logging in

Start the rails server

```bash
bundle exec rails s
```

You can login by visiting https://mdl.devlocal/users/sign_in

username: local@example.com
password: password

## Interacting with the App on the Command Line

Enter an interactive session with the application (must be running in another tab):

`$ bundle exec rails console`

## Troubleshooting

* [MySQL] If you run into issues with the database, try removing and recreating the db volumes:
  * `$ docker-compose down -v; docker-compose up`

## Updating the Webpacker Image

When you update certain frontend elements of the app, you'll need to rebuild the webpacker image. Things like adding a new "pack" (entrypoint), adding or removing dependencies, and updating the version of NodeJS all require rebuilding the image. Here's how you do it:

1) Find the container ID of the webpacker container

    `docker ps -qa -f name=webpacker`

2) If it's running, stop it

    `docker stop $CONTAINER_ID`

3) remove the container:

    `docker rm $CONTAINER_ID`

4) Find the image(s)

    `docker images mdl_search_webpacker -q`

5) Remove the images

    `docker rmi $IMAGE_ID`

6) Build the new image (assuming you're done making changes for now)

    `docker-compose build webpacker`

7) Run the container

    `docker-compose up -d webpacker`


# Testing

```bash
###
# Full suite
bundle exec rspec

###
# Single directory
bundle exec rspec spec/features/

###
# Single file
bundle exec rspec spec/lib/borealis_image_spec.rb
```

We have separate Docker containers for development and test environments so that you can run tests without
worrying about affecting your local development data.

# Developer Tips

* "How to I add/remove/change X feature in the UI?"
  * MDL Search makes use of a [Rails Engine](https://guides.rubyonrails.org/engines.html) called "[Blacklight](https://github.com/projectblacklight/blacklight)". Rails engines are like little Rails apps that you override within your own app. If there is a UI feature you want to alter or remove, you may need to hunt around a bit in Blacklight to find it. Tip: browse the HTML source of the feature you are looking for and search the Blacklight view codebase (for your [specific version](https://github.com/projectblacklight/blacklight/tree/v6.10.1/app/views)) for small unique html snippets from the interface; sometimes you'll get lucky. Other times, you may have to browse through template render calls until you find what you are looking for.

# Docker Help

## Some aliases for your shell

```bash
# Note: you might consider adding aliases (shortcuts) in your shell env to make it easier to run these commands. e.g.:
# alias dps='docker ps -a'

# Show all docker images
$ docker ps -a

# Force Remove all MDL images
$ docker-compose stop; docker rmi -f $(docker images -q --filter="reference=mdl*")

# Remove all inactive Docker images (ones that have "Exited")
$ docker rm $(docker ps -a | grep Exited | awk '\''BEGIN { FS=" " } ; {print $1;}'\'')

# CAREFUL! Scorched earth! remove all Docker images
$ docker rmi $(docker images | grep "^<none>" | awk "{print $3}")
```

## Useful Tools

* [Docker Dive](https://github.com/wagoodman/dive)

This is especially useful for analyzing containers to see why they are the size that they are and finding ways to slim them down.

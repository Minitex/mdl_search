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

Install Ruby 2.4 via [RVM](http://rvm.io/) or [rbenv](https://github.com/rbenv/rbenv)

(rvm instructions)
```bash
rvm install ruby-2.4
```

Install MySQL and Redis clients, as well as geckodriver for system tests run via Selenium.

```bash
brew install mysql@5.7 redis geckodriver
```

Install Node via [NVM](https://github.com/nvm-sh/nvm) (or preferred alternative)

```bash
nvm install 12
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

[Ingest some content](https://github.com/Minitex/mdl_search/wiki/Development-Environment-Setup#ingest-some-content)

## Logging in

Start the rails server

```bash
bundle exec rails s
```

You can login by visiting http://localhost:3000/users/sign_in

username: local@example.com
password: password

## Interacting with the App on the Command Line

Enter an interactive session with the application (must be running in another tab):

`$ bundle exec rails console`

## Troubleshooting

* [MySQL] If you run into issues with the database, try nuking the db volumes and restarting:
  * `$ docker-compose down -v; docker-compose up`

## Updating the React Component

The React dependency associated with this project are included in the `package.json` file and tied to specific commits:

```json
  ...
    "react-citation": "git+https://github.com/UMNLibraries/react-citation.git#52091d617b5d",
  ...
```

After running the production build process on one of these projects and pushing the new files to GitHub, include the new commit hash in the `mdl_search` project `package.json` file and run the following command (located in the root directory of this repo): `./yarn_rebuild.sh`.

For more details on how to develop and build these React components, see the [React Borealis project page](https://github.com/UMNLibraries/react-borealis).

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

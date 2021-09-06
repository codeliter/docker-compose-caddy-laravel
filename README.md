# docker-compose-laravel-caddy

A simplified Docker Compose workflow that sets up a Linux (Alpine Linux), Caddy, Redis, and MariaDB network of
containers for local Laravel development.

## Requirements

- [Docker](https://docs.docker.com/get-docker/) >= 20.10.8
- [Docker Compose](https://docs.docker.com/compose/install/) >= 1.26.0

## Usage

- Make sure you have *docker* and *docker-compose* installed.


- Clone your code into the [src](src) directory.
  <br/>


- Create a **.env** in this directory.
    - **PHPGROUP**: This can be the username/group of the current user on the host machine.
    - **PHPUSER**: This can be the username of the current user on the host machine.
    - **DB_DATABASE**: This is the database your application wants to use.
    - **DB_USERNAME**: This is the username the application connects to.
    - **DB_PASSWORD**: This is the password of the database the application connects to.


- Navigate to this directory in your terminal, Run:
  ```bash
  docker-compose up -d --build caddy
  ```


- Bringing up the services exposes the following services on your machine:
    - **caddy** - `:8200`
    - **mysql** - `:3306`
    - **redis** - `:6379`
    - **app** - `:9001`
    - **mailhog** - `:8025`

## Available Commands

- **Composer**
  ```bash
  docker-compose run --rm composer update
  ```

- Artisan
  ```bash
  docker-compose run --rm  app php artisan migrate
  ```

- Php
  ```bash
  docker-compose run --rm  app php
  ```

## Persisting MySQL

Persisting mysql to the host machine disk is pretty easy.

- Create a directory on your machine. Example create a directory in the path: **_/data/mysql_**
- Modify the **mysql** under the services in the [docker-compose.yml](./docker-compose.yml)
- Change the volume mapping to the path on your local machine
  ``` 
      volumes:
      - '/data/mysql:/var/lib/mysql'
  ```
  The **/data/mysql** must be a directory that exists on your local machine.
- Kill the container using `docker-compose down`, then restart.

## Persisting Redis

Persisting redis to the host machine disk is pretty easy.

- Create a directory on your machine. Example create a directory in the path: **_/data/redis_**
- Modify the **redis** under the services in the [docker-compose.yml](./docker-compose.yml)
- Change the volume mapping to the path on your local machine
  ``` 
      volumes:
      - '/data/redis:/bitnami/redis/datum'
  ```
  The **/data/redis** must be a directory that exists on your local machine.
- Kill the container using `docker-compose down`, then restart.

## MailHog

The current version of Laravel (8 as of today) uses MailHog as the default application for testing email sending and
general SMTP work during local development. The mailhog service is included in the `docker-compose.yml` file, and spins
up alongside the laravel application, redis and mysql services.

To see the dashboard and view any emails coming through the system, visit [localhost:8025](http://localhost:8025) after
running `docker-compose up -d caddy`.

## Using BrowserSync with Laravel Mix

If you want to enable the hot-reloading that comes with Laravel Mix's BrowserSync option, add the following to the end
of your Laravel project's `webpack.mix.js` file:

```javascript
.browserSync({
    proxy: 'nginx',
    open: false,
    port: 4000,
});
```

From your terminal window at the project root, run the following command to start watching for changes with the npm
container and its mapped ports:

```bash
docker-compose run --rm --service-ports npm run watch
```
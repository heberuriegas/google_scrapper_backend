# Setup

To setup run the commands below:

```
cp .env.sample .env

docker compose up --build
```

To run tests:

```
docker compose run --rm backend rspec
```

# README

## Add gems to this project

Because this project lives in a Docker container you need to do something different than ```bundle```

In the root of this project run:
```
docker-compose -f docker-compose.yml -f front-end/docker-compose.yml run web bundle'
docker-compose -f docker-compose.yml -f front-end/docker-compose.yml build'
```

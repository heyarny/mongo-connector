# mongo-connector

An easy to use docker image to run mongo-connector via docker-compose.yml.

Available on docker hub https://hub.docker.com/r/heyarny/mongo-connector

## docker-compose


```yml
version: '3.7'

services:

  # mongodb
  mongo1:
    image: mongo:3.6
    volumes:
      - ./data_db:/data/db
    entrypoint: [ "/usr/bin/mongod", "--bind_ip_all", "--replSet", "rs0" ]
    ports:
      - 27020:27017
    restart: always

  # elasticsearch
  es01:
    image: docker.elastic.co/elasticsearch/elasticsearch:5.6.16
    environment:
      - cluster.name=docker-cluster
      - bootstrap.memory_lock=true
      - xpack.security.enabled=false
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - esdata01:/usr/share/elasticsearch/data
    ports:
      - 9200:9200

  # replica to prepare mongodb
  mongo_replica_setup:
    image: heyarny/mongo-replica-set:latest
    depends_on:
      - mongo1
    environment:
      MONGO_HOSTS: mongo1
      MONGO_REPLSET: rs0

  # mongo & elasticsearch sync
  mongo-connector:
    image: heyarny/mongo-connector:latest
    restart: always # let it retry.. servers might be starting
    depends_on:
      - mongo1
      - es01
    environment:
      MAIN: mongodb://mongo1:27017
      TARGET: es01:9200
      ARGS: -n foobar.teest

```

**MAIN** = source uri of your database.

**TARGET** = target uri of your elasticsearch database.

## License
[WTFPL](https://en.wikipedia.org/wiki/WTFPL)

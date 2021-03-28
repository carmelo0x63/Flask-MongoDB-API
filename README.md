# Flask-MongoDB-API
Flask-based API offering CRUD operations, backend DB is MongoDB

### Setup
Create a [virtual environment for Python](https://docs.python.org/3/library/venv.html) in the current directory
```
$ python3 -m venv .
```

Activate the virtual environment and install any dependencies
```
$ source bin/activate

(Flask-MongoDB-API) pip3 install --upgrade pip

(Flask-MongoDB-API) pip3 install wheel

(Flask-MongoDB-API) pip3 install -r requirements.txt
```

____

### Option 1: run `app.py` from CLI

#### Manually start the backend DB
```
$ docker run --name mongodb -p 27017:27017 -d mongo:latest
```

file: `app.py`
```
# Flask-MongoDB-API/app.py
# Modularized through Blueprints, routes have been moved to resources/movie.py

from flask import Flask
from database.db import initialize_db
from resources.movie import movies

app = Flask(__name__)

app.config['MONGODB_SETTINGS'] = {
    'host': 'mongodb://localhost/movie-bag'
}

initialize_db(app)
app.register_blueprint(movies)

if __name__ == '__main__':
    app.run()
```

#### Run with
```
(Flask-MongoDB-API) $ export FLASK_APP=app.py

(Flask-MongoDB-API) $ flask run --host=0.0.0.0
```
**NOTE**: the `--host=0.0.0.0` part is optional and is meant to make the web server accessible from external hosts. Use with caution!

#### Exit with
CTRL+C to stop the server, `deactivate` to quit the virtual environment

#### Tests
##### Create/POST
```
$ curl -H "Content-Type: application/json" --data '{"name": "The Dark Knight", "casts": ["Christian Bale", "Heath Ledger", "Aaron Eckhart", "Michael Caine"], "genres": ["Action", "Crime"]}' -X POST http://127.0.0.1:5000/movies
{"id":"5eb41dc4c2d65db25809b565"}

$ curl -H "Content-Type: application/json" --data '{"name": "The Shawshank Redemption", "casts": ["Tim Robbins", "Morgan Freeman", "Bob Gunton", "William Sadler"], "genres": ["Drama"]}
' -X POST http://127.0.0.1:5000/movies
{"id":"5eb41edac2d65db25809b566"}

$ curl -H "Content-Type: application/json" --data '{"name": "The Godfather ", "casts": ["Marlon Brando", "Al Pacino", "James Caan", "Diane Keaton"], "genres": ["Crime", "Drama"]}' -X POST http://127.0.0.1:5000/movies
{"id":"5eb41eeac2d65db25809b567"}
```

##### Read/GET
```
$ curl -H "Content-Type: application/json" -X GET http://127.0.0.1:5000/movies
[{"_id": {"$oid": "605c9602ec1a1b84930c873e"}, "name": "The Dark Knight", "casts": ["Christian Bale", "Heath Ledger", "Aaron Eckhart", "Michael Caine"], "genres": ["Action", "Crime"]}, {"_id": {"$oid": "605c960dec1a1b84930c873f"}, "name": "The Shawshank Redemption", "casts": ["Tim Robbins", "Morgan Freeman", "Bob Gunton", "William Sadler"], "genres": ["Drama"]}, {"_id": {"$oid": "605c9617ec1a1b84930c8740"}, "name": "The Godfather ", "casts": ["Marlon Brando", "Al Pacino", "James Caan", "Diane Keaton"], "genres": ["Crime", "Drama"]}]
```

##### Update/PUT
```
$ curl -H "Content-Type: application/json" --data '{"name": "The Dark Knight UPDATED", "casts": ["Christian Bale", "Heath Ledger", "Aaron Eckhart", "Michael Caine"], "genres": ["Action", "Crime", "Drama"]}' -X PUT http://127.0.0.1:5000/movies/5eb41dc4c2d65db25809b565

$ curl -H "Content-Type: application/json" -X GET http://127.0.0.1:5000/movies/5eb41dc4c2d65db25809b565
{"_id": {"$oid": "5eb41dc4c2d65db25809b565"}, "name": "The Dark Knight UPDATED", "casts": ["Christian Bale", "Heath Ledger", "Aaron Eckhart", "Michael Caine"], "genres": ["Action", "Crime", "Drama"]}
```

##### Delete/DELETE
```
$ curl -H "Content-Type: application/json" -X DELETE http://127.0.0.1:5000/movies/5eb41dc4c2d65db25809b565

$ curl -H "Content-Type: application/json" -X GET http://127.0.0.1:5000/movies/5eb41dc4c2d65db25809b565

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<title>500 Internal Server Error</title>
<h1>Internal Server Error</h1>
<p>The server encountered an internal error and was unable to complete your request. Either the server is overloaded or there is an error in the application.</p>
```

____

### Option 2: Docker-Compose

#### Build
file `Dockerfile`:
```
FROM python:3-alpine3.13
MAINTAINER "carmelo.califano@gmail.com"

#RUN apk add --no-cache curl
WORKDIR /srv

COPY app.py requirements.txt /srv/
COPY database /srv/database/
COPY resources /srv/resources/
RUN pip3 install -r requirements.txt

ENV FLASK_APP "/srv/app.py"
EXPOSE 5000/tcp
ENTRYPOINT ["flask", "run", "--host=0.0.0.0"]
```

file `docker-compose.yaml`:
```
version: "3"
services:
  rest:
    build: .
    ports:
      - "5000:5000"
    depends_on:
      - db
    networks:
      - frontend
      - backend
  db:
    image: mongo
    ports:
      - "27017:27017"
    networks:
      - backend
networks:
  frontend:
  backend:
```

**NOTE**: edit `app.py` as follows:
```
<     'host': 'mongodb://localhost/movie-bag'
---
>     'host': 'mongodb://flask-mongodb-api_db_1/movie-bag'
```

#### Run
```
$ docker-compose up -d
Building rest
Sending build context to Docker daemon  25.57MB
...
Successfully tagged flask-mongodb-api_rest:latest
WARNING: Image for service rest was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.
Starting flask-mongodb-api_db_1 ... done
Starting flask-mongodb-api_rest_1 ... done

$ docker-compose ps
          Name                       Command             State            Ports
-----------------------------------------------------------------------------------------
flask-mongodb-api_db_1     docker-entrypoint.sh mongod   Up      0.0.0.0:27017->27017/tcp
flask-mongodb-api_rest_1   flask run --host=0.0.0.0      Up      0.0.0.0:5000->5000/tcp
```
____

### Resources
- [Flask](https://flask.palletsprojects.com/en/1.1.x/)
- [Dockerize a Flask App](https://dev.to/riverfount/dockerize-a-flask-app-17ag)
- [Setup & basic CRUD API](https://dev.to/paurakhsharma/flask-rest-api-part-0-setup-basic-crud-api-4650)
- [Using MongoDB w/ Flask](https://dev.to/paurakhsharma/flask-rest-api-part-1-using-mongodb-with-flask-3g7d)
- [Better structure with Blueprint and flask-restful](https://dev.to/paurakhsharma/flask-rest-api-part-2-better-structure-with-blueprint-and-flask-restful-2n93)
- [Authentication and authorization](https://dev.to/paurakhsharma/flask-rest-api-part-3-authentication-and-authorization-5935)
- [Exception handling](https://dev.to/paurakhsharma/flask-rest-api-part-4-exception-handling-5c6a)
- [Password reset](https://dev.to/paurakhsharma/flask-rest-api-part-5-password-reset-2f2e)
- [Testing REST API](https://dev.to/paurakhsharma/flask-rest-api-part-6-testing-rest-apis-4lla)
- [Manage data in Docker](https://docs.docker.com/storage/)
- [Persistent Databases Using Docker’s Volumes and MongoDB](https://betterprogramming.pub/persistent-databases-using-dockers-volumes-and-mongodb-9ac284c25b39)


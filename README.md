# Flask-CRUD-API
Flask-based API offering CRUD operations, backend DB is MongoDB

#### Setup
Create a [virtual environment for Python](https://docs.python.org/3/library/venv.html) in the current directory
```
$ python3 -m venv .
```

Activate the virtual environment and install any dependencies
```
$ source bin/activate

(Flask-CRUD-API) pip3 install --upgrade pip

(Flask-CRUD-API) pip3 install wheel

(Flask-CRUD-API) pip3 install -r requirements.txt
```

<!--#### Start the backend DB
```
$ docker run --name mongodb -p 27017:27017 -d mongo:latest
```-->

#### Run with
```
(Flask-CRUD-API) $ export FLASK_APP=app.py

(Flask-CRUD-API) $ flask run --host=0.0.0.0
```
**NOTE**: the `--host=0.0.0.0` part is optional and is only meant to make the web server accessible from external hosts

#### Exit with
CTRL+C to stop the server, `deactivate` to quit the virtual environment

#### Tests
#### Create/POST
```
$ curl -H "Content-Type: application/json" --data '{"name": "The Dark Knight UPDATED", "casts": ["Christian Bale", "Heath Ledger", "Aaron Eckhart", "Michael Caine"], "genres": ["Action", "Crime", "Drama"]}' -X POST http://127.0.0.1:5000/movies
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
[{"_id": {"$oid": "5eb41dc4c2d65db25809b565"}, "name": "The Dark Knight UPDATED", "casts": ["Christian Bale", "Heath Ledger", "Aaron Eckhart", "Michael Caine"], "genres": ["Action", "Crime", "Drama"]}, {"_id": {"$oid": "5eb41edac2d65db25809b566"}, "name": "The Shawshank Redemption", "casts": ["Tim Robbins", "Morgan Freeman", "Bob Gunton", "William Sadler"], "genres": ["Drama"]}, {"_id": {"$oid": "5eb41eeac2d65db25809b567"}, "name": "The Godfather ", "casts": ["Marlon Brando", "Al Pacino", "James Caan", "Diane Keaton"], "genres": ["Crime", "Drama"]}]
```

##### Update/PUT
```
$ curl -H "Content-Type: application/json" --data '{"name": "The Dark Knight", "casts": ["Christian Bale", "Heath Ledger", "Aaron Eckhart", "Michael Caine"], "genres": ["Action", "Crime", "Drama"]}' -X PUT http://127.0.0.1:5000/movies/5eb41dc4c2d65db25809b565

$ curl -H "Content-Type: application/json" -X GET http://127.0.0.1:5000/movies/5eb41dc4c2d65db25809b565
{"_id": {"$oid": "5eb41dc4c2d65db25809b565"}, "name": "The Dark Knight", "casts": ["Christian Bale", "Heath Ledger", "Aaron Eckhart", "Michael Caine"], "genres": ["Action", "Crime", "Drama"]}
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

#### Docker
```
$ docker build -t <repo>/flask-crud-api:1.0 .

$ docker run -d --name flask-crud-api -p 5000:5000 <repo>/flask-crud-api:1.0
```

____

#### Resources
- [Flask](https://flask.palletsprojects.com/en/1.1.x/)
- [Build a CRUD Web App With Python and Flask - Part One](https://www.digitalocean.com/community/tutorials/build-a-crud-web-app-with-python-and-flask-part-one)
- [Dockerize a Flask App](https://dev.to/riverfount/dockerize-a-flask-app-17ag)


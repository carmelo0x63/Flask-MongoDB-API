# Flask-CRUD-API
Flask-based API offering CRUD operations, Mongodb

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

#### Start the backend DB
```
$ docker run --name mongodb -p 27017:27017 -d mongo:latest
```

#### Run with
```
(Flask-CRUD-API) $ export FLASK_APP=app.py

(Flask-CRUD-API) $ flask run --host=0.0.0.0
```
**NOTE**: the `--host=0.0.0.0` part is optional and is only meant to make the web server accessible from external hosts

#### Exit with
CTRL+C to stop the server, `deactivate` to quit the virtual environment

____

#### Docker
```
$ docker build -t <repo>/Flask-CRUD-API:1.0 .

$ docker run -d --name Flask-CRUD-API -p 5000:5000 <repo>/Flask-CRUD-API:1.0
```

____

#### Resources
- [Flask](https://flask.palletsprojects.com/en/1.1.x/)
- [Getting Started With Flask, A Python Microframework](https://scotch.io/tutorials/getting-started-with-flask-a-python-microframework)
- [Dockerize a Flask App](https://dev.to/riverfount/dockerize-a-flask-app-17ag)


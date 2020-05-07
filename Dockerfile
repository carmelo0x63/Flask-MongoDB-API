FROM python:3-alpine3.9
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

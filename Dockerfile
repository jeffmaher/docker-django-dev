FROM python:3.8-alpine

RUN apk add git

RUN pip install django==3.0.6

WORKDIR /workspace

CMD sh
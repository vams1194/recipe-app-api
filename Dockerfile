# Create a base image
FROM python:3.9-alpine3.13
# Recommended to add the maintainer to let other developers know who the maintainer is for the app
LABEL maintainer="vams1194@protonmail.com"

# Makes the output shows up directly to the console without delay. Logs shows up as they run
ENV PYTHONUNBUFFERED=1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# The run commands after creating image. This is a single-line command divided by "\" to prevent creating multiple image layers if done without this
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true"]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user
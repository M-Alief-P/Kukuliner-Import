FROM python:3.12-slim

RUN apt-get update
RUN apt-get install -y gcc
RUN apt-get install sudo
RUN apt update && apt install --no-install-recommends -y python3-dev default-libmysqlclient-dev build-essential pkg-config libssl-dev

# Allow statements and log messages to imediately appear in the logs
ENV PYTHONUNBUFFERED True
# Copy local code to the container image
ENV APP_HOME /back-end
WORKDIR ${APP_HOME}
COPY . ./

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8080

# Run the web service on container startup. Here we use the gunicorn
# webserver, with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
# Timeout is set to 0 to disable the timeouts of the workers to allow Cloud Run to handle instance scaling.
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 app:app

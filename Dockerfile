# base image
FROM python:3.7

# info
LABEL maintainer="heyarny@github"

# install mongo connector
RUN pip install 'mongo-connector[elastic5]'

# copy the shell script
COPY run_connector.sh /
RUN chmod +x /run_connector.sh

# start setup
CMD ["/run_connector.sh"]

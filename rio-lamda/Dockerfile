#
# Rock R Server Dockerfile with DataSHIELD Rio Lamda profile
#
# https://github.com/datashield/docker-rock
#

# R 4.5.2, Rock 2.2.0
FROM datashield/rock-base:6.3.4-R4.5.2

ENV ROCK_LIB=/var/lib/rock/R/library

# Update of packages
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    R -q -e "update.packages(ask=FALSE)" && \
    chown -R rock $ROCK_LIB && \
    rm -rf /var/lib/apt/lists/*

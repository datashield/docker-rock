#
# Rock R Server Dockerfile for 'molgenis-rock-base' profile
#
# https://github.com/datashield/docker-rock
#

# Use Rock 2.1.6, dsBase 6.3.4, R 4.5.2
FROM datashield/rock-base:6.3.4-R4.5.2

ENV ROCK_VERSION=2.1.6
ENV DSBASE_VERSION=6.3.4
ENV DSTIDYVERSE_VERSION=v1.1.1

ENV ROCK_LIB=/var/lib/rock/R/library

# Create Labels

LABEL rock=$ROCK_VERSION
LABEL dsBase=$DSBASE_VERSION
LABEL dsTidyverse=$DSTIDYVERSE_VERSION

# Update of packages
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    R -q -e "update.packages(ask=FALSE)" && \
    chown -R rock $ROCK_LIB && \
    rm -rf /var/lib/apt/lists/*

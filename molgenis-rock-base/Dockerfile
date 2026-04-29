#
# Rock R Server Dockerfile for 'molgenis-rock-base' profile
#
# https://github.com/datashield/docker-rock
#

# Use Rock 2.2.0, dsBase 6.3.5, R 4.5.2
FROM datashield/rock-base:6.3.5-R4.5.2

ENV ROCK_VERSION=2.2.0
ENV DSBASE_VERSION=6.3.5
ENV DSTIDYVERSE_VERSION=v1.2.1

ENV ROCK_LIB=/var/lib/rock/R/library

# Create DataSHIELD Labels

LABEL rock=$ROCK_VERSION
LABEL dsBase=$DSBASE_VERSION
LABEL dsTidyverse=$DSTIDYVERSE_VERSION

# Update of packages
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    Rscript -e "utils::update.packages(ask=FALSE)" && \
    Rscript -e "remotes::install_github('datashield/dsBase', ref = '$DSBASE_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
    Rscript -e "remotes::install_github('molgenis/dsTidyverse', ref = '$DSTIDYVERSE_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
    chown -R rock $ROCK_LIB && \
    rm -rf /var/lib/apt/lists/*

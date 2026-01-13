#
# Rock R Server Dockerfile for 'molgenis rock base permissive' profile
#
# https://github.com/datashield/docker-rock
#

# Use 'datashield/molgenis-rock-base:1.0.0'
FROM datashield/molgenis-rock-base:1.0.0

ENV DSBASE_VERSION=v6.3.4-permissive

ENV ROCK_LIB=/var/lib/rock/R/library

# Create Labels

LABEL dsBase=$DSBASE_VERSION

# Update of packages - dsBase
RUN Rscript -e "remotes::install_github('datashield/dsBase', ref = '$DSBASE_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
    chown -R rock $ROCK_LIB

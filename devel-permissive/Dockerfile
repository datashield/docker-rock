#
# Rock R Server Dockerfile for 'rock devel permissive' profile
#
# https://github.com/datashield/docker-rock
#

# Use 'datashield/rock_devel:1.1.0'
FROM datashield/rock_devel:1.1.0

ENV DSBASE_VERSION=v6.3.5-permissive

ENV ROCK_LIB=/var/lib/rock/R/library

# Create Labels

LABEL dsBase=$DSBASE_VERSION

# Update of packages - dsBase
RUN Rscript -e "remotes::install_github('datashield/dsBase', ref = '$DSBASE_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
    chown -R rock $ROCK_LIB

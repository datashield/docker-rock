#
# Rock R Server Dockerfile with DataSHIELD Tulip Donkey permissive profile
#
# https://github.com/datashield/docker-rock
#

FROM datashield/rock-urban-devel:2.0.0

ENV DSBASE_VERSION=v7.0-dev-permissive

ENV ROCK_LIB=/var/lib/rock/R/library

LABEL dsBase=$DSBASE_VERSION

# dsBase
RUN Rscript -e "remotes::install_github('datashield/dsBase', ref = '$DSBASE_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
  chown -R rock $ROCK_LIB

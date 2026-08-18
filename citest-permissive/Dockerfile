#
# Rock R Server Dockerfile with DataSHIELD CI Test permissive profile
#
# https://github.com/datashield/docker-rock
#

FROM datashield/rock_citest:4.0.0

ENV DSBASE_VERSION=v6.3.6-dev-permissive

ENV ROCK_LIB=/var/lib/rock/R/library

LABEL dsBase=$DSBASE_VERSION

# dsBase
RUN Rscript -e "remotes::install_github('datashield/dsBase', ref = '$DSBASE_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
  chown -R rock $ROCK_LIB

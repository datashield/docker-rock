#
# Rock R Server Dockerfile with DataSHIELD Omicron Karma permissive profile
#
# https://github.com/datashield/docker-rock
#

FROM datashield/rock-omicron-karma:1.0.0

ENV DSBASE_VERSION=v6.3.3-permissive

ENV ROCK_LIB=/var/lib/rock/R/library

# dsBase
RUN Rscript -e "remotes::install_github('datashield/dsBase', ref = '$DSBASE_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
  chown -R rock $ROCK_LIB

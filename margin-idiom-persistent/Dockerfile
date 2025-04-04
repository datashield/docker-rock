#
# Rock R Server Dockerfile with DataSHIELD Margin Hammer Permissive profile
#
# https://github.com/datashield/docker-rock
#

# R 4.4.2, Rock 2.1.3
FROM datashield/rock-margin-idiom:latest

ENV DSBASE_VERSION=v6.3.1-permissive

ENV ROCK_LIB=/var/lib/rock/R/library

# Update of packages
RUN apt-get update -y
RUN apt-get upgrade -y
RUN R -q -e "update.packages()"

# Install new R packages
# dsBase
RUN Rscript -e "remotes::install_github('datashield/dsBase', ref = '$DSBASE_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
  chown -R rock $ROCK_LIB

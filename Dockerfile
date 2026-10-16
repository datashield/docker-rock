#
# Rock R Server Dockerfile with DataSHIELD
#
# https://github.com/datashield/docker-rock
#

# Base image tag suffix: '' (JVM) or '-native' (native executable)
ARG VARIANT=''

FROM obiba/rock:2.3.0-R4.6.1${VARIANT}

LABEL DataSHIELD=<info@datashield.ac.uk>

# Versions of dsBase and dsTidyverse to install from GitHub
ENV DSBASE_VERSION=6.3.5
ENV DSTIDYVERSE_VERSION=v1.2.1

ENV ROCK_LIB=/var/lib/rock/R/library

RUN \
  # Additional system dependencies
  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y cmake && \
  # Update R packages
  # Rscript -e "update.packages(ask = FALSE, repos = c('https://cloud.r-project.org'), instlib = '/usr/local/lib/R/site-library')" && \
  # Install new R packages
  install2.r --error --skipmissing -l $ROCK_LIB -r $ROCK_REPOS -d TRUE dsBase dsTidyverse && \
  # Install specific versions of dsBase and dsTidyverse from GitHub (installGithub.r has no lib option: R_LIBS puts the Rock library first)
  R_LIBS=$ROCK_LIB installGithub.r -d TRUE -u FALSE -r $ROCK_REPOS -r https://cran.datashield.org molgenis/ds-tidyverse@$DSTIDYVERSE_VERSION datashield/dsBase@$DSBASE_VERSION && \
  chown -R rock $ROCK_LIB

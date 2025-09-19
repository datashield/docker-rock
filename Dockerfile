#
# Rock R Server Dockerfile with DataSHIELD
#
# https://github.com/datashield/docker-rock
#

FROM obiba/rock:2.1.5-R4.5.1

LABEL DataSHIELD=<info@datashield.ac.uk>

ENV DSBASE_VERSION=6.3.4
ENV DSTIDYVERSE_VERSION=v1.0.4

ENV ROCK_LIB=/var/lib/rock/R/library

RUN \
  # Additional system dependencies
  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y cmake && \
  # Update R packages
  #Rscript -e "update.packages(ask = FALSE, repos = c('https://cloud.r-project.org'), instlib = '/usr/local/lib/R/site-library')" && \
  # Install new R packages
  Rscript -e "remotes::install_github('molgenis/ds-tidyverse', ref = '$DSTIDYVERSE_VERSION', repos = c('https://cloud.r-project.org', 'https://cran.datashield.org'), dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
  Rscript -e "remotes::install_github('datashield/dsBase', ref = '$DSBASE_VERSION', repos = c('https://cloud.r-project.org', 'https://cran.datashield.org'), dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
  chown -R rock $ROCK_LIB

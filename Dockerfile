#
# Rock R Server Dockerfile with DataSHIELD
#
# https://github.com/datashield/docker-rock
#

FROM obiba/rock:2.2.1-R4.5.3

LABEL DataSHIELD=<info@datashield.ac.uk>

# Uncomment the following lines to specify versions of dsBase and dsTidyverse to install from GitHub
# ENV DSBASE_VERSION=6.3.5
# ENV DSTIDYVERSE_VERSION=v1.2.1

ENV ROCK_LIB=/var/lib/rock/R/library

RUN \
  # Additional system dependencies
  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y cmake && \
  # Update R packages
  # Rscript -e "update.packages(ask = FALSE, repos = c('https://cloud.r-project.org'), instlib = '/usr/local/lib/R/site-library')" && \
  # Install new R packages
  Rscript -e "install.packages(c('dsBase', 'dsTidyverse'), repos = c('https://cloud.r-project.org'), dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
  # Uncomment the following lines to install specific versions of dsBase and dsTidyverse from GitHub
  # Rscript -e "remotes::install_github('molgenis/ds-tidyverse', ref = '$DSTIDYVERSE_VERSION', repos = c('https://cloud.r-project.org', 'https://cran.datashield.org'), dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
  # Rscript -e "remotes::install_github('datashield/dsBase', ref = '$DSBASE_VERSION', repos = c('https://cloud.r-project.org', 'https://cran.datashield.org'), dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
  chown -R rock $ROCK_LIB

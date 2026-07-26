#
# Rock R Server Dockerfile with DataSHIELD Margin Gypsum profile
#
# https://github.com/datashield/docker-rock
#

# R 4.6.1, Rock 2.2.1
FROM datashield/rock-base:6.3.5-R4.5.3

ENV DSTIDYVERSE_VERSION=v1.2.2
ENV DSBASE_VERSION=v7.0-dev

ENV ROCK_LIB=/var/lib/rock/R/library

LABEL dsTidyverse=${DSTIDYVERSE_VERSION}
LABEL dsBase=${DSBASE_VERSION}

# Update of packages
RUN apt-get update -y \
 && apt-get upgrade -y \
 && R -q -e "update.packages()"

# Install new R packages
# dsTidyverse
RUN Rscript -e "remotes::install_github('molgenis/ds-tidyverse', ref = '$DSTIDYVERSE_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" \
  && Rscript -e "remotes::install_github('datashield/dsBase', ref = '$DSBASE_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" \
  && chown -R rock $ROCK_LIB

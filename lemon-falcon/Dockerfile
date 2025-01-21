#
# Rock R Server Dockerfile with DataSHIELD Lemon Donkey profile
#
# https://github.com/datashield/docker-rock
#

# R 4.4.2, Rock 2.1.1
FROM datashield/rock-base:6.3.1-R4.4.2

ENV DSSURVIVAL_VERSION=v2.2.0-dev
ENV DSTIDYVERSE_VERSION=v1.0.1
ENV DSBASE_VERSION=6.3.1

ENV ROCK_LIB=/var/lib/rock/R/library

# Update of packages
RUN apt-get update -y
RUN apt-get upgrade -y
RUN R -q -e "update.packages()"

# Install new R packages
# dsTidyverse
RUN Rscript -e "remotes::install_github('molgenis/ds-tidyverse', ref = '$DSTIDYVERSE_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')"
# dsSurvival
RUN Rscript -e "remotes::install_github('datashield/dsSurvival', ref = '$DSSURVIVAL_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')"
# dsBase
RUN Rscript -e "remotes::install_github('datashield/dsBase', ref = '$DSBASE_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
  chown -R rock $ROCK_LIB

#
# Rock R Server Dockerfile with DataSHIELD Margin Idiom profile
#
# https://github.com/datashield/docker-rock
#

# R 4.5.0, Rock 2.1.4
FROM datashield/rock-base:6.3.2-R4.5.0

ENV DSSURVIVAL_VERSION=v2.3.0-dev
ENV DSTIDYVERSE_VERSION=v1.0.4
ENV DSBASE_VERSION=6.3.2

ENV ROCK_LIB=/var/lib/rock/R/library

# Update of packages
RUN apt-get update -y; apt-get upgrade -y; apt-get autoremove -y
RUN R -q -e "install.packages('ranger')"; R -q -e "update.packages()"

# Install new R packages
# dsTidyverse
RUN Rscript -e "remotes::install_github('molgenis/ds-tidyverse', ref = '$DSTIDYVERSE_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
# dsSurvival
    Rscript -e "remotes::install_github('datashield/dsSurvival', ref = '$DSSURVIVAL_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
# dsBase
    Rscript -e "remotes::install_github('datashield/dsBase', ref = '$DSBASE_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
  chown -R rock $ROCK_LIB

#
# Rock R Server Dockerfile with DataSHIELD Urban Latent profile
#
# https://github.com/datashield/docker-rock
#

# R 4.6.1, Rock 2.3.0
FROM datashield/rock-base:6.3.5-R4.6.1

ENV DSBASE_VERSION=v7.0-dev
ENV DSTIDYVERSE_VERSION=v1.2.2

ENV ROCK_LIB=/var/lib/rock/R/library

# Update of packages
RUN apt-get update -y; apt-get upgrade -y; apt-get autoremove -y && \
    R -q -e "install.packages('ranger')"; R -q -e "update.packages()"

LABEL dsBase=$DSBASE_VERSION
LABEL dsTidyverse=$DSTIDYVERSE_VERSION

# Install new R packages
# dsBase
RUN Rscript -e "remotes::install_github('datashield/dsBase', ref = '$DSBASE_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
# dsTidyverse
# RUN Rscript -e "remotes::install_github('molgenis/ds-tidyverse', ref = '$DSTIDYVERSE_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
    chown -R rock $ROCK_LIB

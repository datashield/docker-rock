#
# Rock R Server Dockerfile with DataSHIELD Margin Idiom profile
#
# https://github.com/datashield/docker-rock
#

# R 4.4.2, Rock 2.2.0
FROM datashield/rock-base:6.3.5-R4.5.2

ENV DSML_VERSION=1.0.1
ENV DSTIDYVERSE_VERSION=v1.2.0
ENV DSBASE_VERSION=6.3.5

ENV ROCK_LIB=/var/lib/rock/R/library

# Update of packages
RUN apt-get update -y; apt-get upgrade -y; apt-get autoremove -y; apt-get clean all -y && \
    R -q -e "install.packages('ranger')"; R -q -e "update.packages()"

# Install new R packages
# dsTidyverse
RUN Rscript -e "remotes::install_github('molgenis/ds-tidyverse', ref = '$DSTIDYVERSE_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
# dsSurvival
    Rscript -e "remotes::install_github('isglobal-brge/dsML', ref = '$DSML_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
# dsBase
    Rscript -e "remotes::install_github('datashield/dsBase', ref = '$DSBASE_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
  chown -R rock $ROCK_LIB

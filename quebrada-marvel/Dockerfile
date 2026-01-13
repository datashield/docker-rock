#
# Rock R Server Dockerfile with DataSHIELD Quebrada Marvel profile
#
# https://github.com/datashield/docker-rock
#

# R 4.5.2, Rock 2.1.6
FROM datashield/rock-base:6.3.4-R4.5.2

ENV DSBASE_VERSION=v6.3.5-dev
ENV DSML_VERSION=v0.1.0-dev

ENV ROCK_LIB=/var/lib/rock/R/library

# Update of packages
RUN apt-get update -y; apt-get upgrade -y; apt-get autoremove -y
RUN R -q -e "install.packages('ranger')"; R -q -e "update.packages()"

# Install new R packages
# dsBase
RUN Rscript -e "remotes::install_github('datashield/dsBase', ref = '$DSBASE_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
# dsML
    Rscript -e "remotes::install_github('StuartWheater/dsML', ref = '$DSML_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
    chown -R rock $ROCK_LIB

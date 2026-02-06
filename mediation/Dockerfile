#
# Rock R Server Dockerfile with DataSHIELD Mediation
#
# https://github.com/datashield/docker-rock
#

FROM datashield/rock-base:6.3.4-R4.5.2

ENV DSMEDIATION_VERSION=0.0.3

ENV ROCK_LIB=/var/lib/rock/R/library

# Install and update new R packages
# medflex and dsMediation
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    R -q -e "update.packages(ask=FALSE)" && \
    Rscript -e "remotes::install_github('kaz-yos/regmedint', ref = 'v0.2.0', dependencies = TRUE, upgrade = TRUE, lib = '$ROCK_LIB')" && \
    Rscript -e "remotes::install_github('jmpsteen/medflex', ref = 'master', dependencies = TRUE, upgrade = TRUE, lib = '$ROCK_LIB')" && \
    Rscript -e "remotes::install_github('datashield/dsMediation', ref = '$DSMEDIATION_VERSION', dependencies = TRUE, upgrade = TRUE, lib = '$ROCK_LIB')" && \
    chown -R rock $ROCK_LIB

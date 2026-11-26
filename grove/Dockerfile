#
# Rock R Server Dockerfile with DataSHIELD GROVE profile
#
# https://github.com/datashield/docker-rock
#
# ---------------------------------------------------------------------------
# GLOBAL VARIABLES
# ---------------------------------------------------------------------------
# GitHub repository and version of dsGeospatial.
ARG DSGEOSPATIAL_REPO=FederatedMethods/dsGeospatial
# IMPORTANT: Supply a release tag or commit SHA at build time.
ARG DSGEOSPATIAL_REF=755928247c4e9c520bf7af364999d4ce263ee461
ARG DSGEOSPATIAL_LAB=0.0.0.9000

# Existing Rock image containing dsBase and dsTidyverse.
FROM datashield/rock-base:6.3.5-R4.6.1

ARG DSGEOSPATIAL_REPO
ARG DSGEOSPATIAL_REF
ARG DSGEOSPATIAL_LAB
ARG CACHEBUST=0
ENV ROCK_LIB=/var/lib/rock/R/library
ENV R_LIBS_SITE=${ROCK_LIB}

USER root

# ---------------------------------------------------------------------------
# SYSTEM DEPENDENCIES
# ---------------------------------------------------------------------------
RUN apt-get update && \
    \
    # Remove conflicting MariaDB development headers.
    dpkg-query -W -f='${binary:Package}\n' 'libmariadb-dev*' 2>/dev/null \
        | xargs -r apt-get remove -y && \
    \
    # Install geospatial development dependencies.
    apt-get install -y --no-install-recommends \
        libudunits2-dev \
        pkg-config \
        libgdal-dev \
        libgeos-dev \
        libproj-dev \
        git \
    && rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------------------
# R DEPENDENCIES
# ---------------------------------------------------------------------------
RUN Rscript -e "\
    install.packages( \
        c( \
          c('Rcpp', 'units', 'spdep', 'remotes', 'spatialreg', 'GWmodel'), \
          c('conleyreg', 'spmodel', 'spmoran') \
        ), \
        lib = Sys.getenv('ROCK_LIB'), \
        repos = 'https://cloud.r-project.org' \
    )"

RUN R_LIBS_SITE="${ROCK_LIB}" Rscript -e "\
    stopifnot( \
        requireNamespace('Rcpp', quietly=TRUE), \
        packageVersion('Rcpp') >= '1.1.0', \
        requireNamespace('units', quietly=TRUE), \
        requireNamespace('spdep', quietly=TRUE), \
        requireNamespace('remotes', quietly=TRUE), \
        requireNamespace('spatialreg', quietly=TRUE), \
        requireNamespace('GWmodel', quietly=TRUE), \
        requireNamespace('conleyreg', quietly=TRUE), \
        requireNamespace('spmodel', quietly=TRUE), \
        requireNamespace('spmoran', quietly=TRUE) \
    )"

# ---------------------------------------------------------------------------
# DATASHIELD PACKAGE VALIDATION
# ---------------------------------------------------------------------------
RUN R_LIBS="${ROCK_LIB}" Rscript -e "\
    stopifnot( \
        as.character(packageVersion('dsBase')) == '6.3.5', \
        as.character(packageVersion('dsTidyverse')) == '1.2.1' \
    ); \
    print(.libPaths()); \
    print(packageVersion('dsBase')); \
    print(packageVersion('dsTidyverse'))"

# Install dsGeospatial at a pinned Git reference.
RUN test -n "${DSGEOSPATIAL_REF}" \
    && R_LIBS="${ROCK_LIB}" Rscript -e "\
        remotes::install_github( \
            '${DSGEOSPATIAL_REPO}', \
            ref='${DSGEOSPATIAL_REF}', \
            lib=Sys.getenv('ROCK_LIB'), \
            upgrade='never', \
            dependencies=TRUE, \
            force=TRUE \
        ); \
        stopifnot(requireNamespace('dsGeospatial', quietly=TRUE))" \
    && chown -R rock "${ROCK_LIB}"
# Record image provenance.
LABEL org.opencontainers.image.source="https://github.com/${DSGEOSPATIAL_REPO}" \
      dsgeospatial.ref="${DSGEOSPATIAL_LAB}"

#
# Rock R Server Dockerfile with DataSHIELD Omicron Karma profile
#
# https://github.com/datashield/docker-rock
#

# R 4.5.0, Rock 2.1.1
FROM datashield/rock-base:6.3.3

# Set environment variables
ENV DSMEDIATION_VERSION=0.0.3 \
    DSEXPOSOME_VERSION=2.0.9 \
    DSTIDYVERSE_VERSION=v1.0.4 \
    DSOMICS_VERSION=v1.0.18-2 \
    DSMTL_VERSION=0.9.9 \
    DSSURVIVAL_VERSION=v2.1.3 \
    DSBASE_VERSION=6.3.3 \
    ROCK_LIB=/var/lib/rock/R/library

# Install new R packages in a single layer to reduce image size
RUN Rscript -e "install.packages('BiocManager', repos = 'https://cloud.r-project.org')" && \
    # Install BiocManager packages first
    Rscript -e "BiocManager::install(c('bumphunter', 'missMethyl', 'rexposome', 'Biobase', 'SNPRelate', 'GENESIS', 'GWASTools', 'GenomicRanges', 'SummarizedExperiment', 'DESeq2', 'edgeR', 'MEAL'), update = FALSE, ask = FALSE, lib = '$ROCK_LIB')" && \
    # Install GitHub packages
    Rscript -e "remotes::install_github('datashield/dsMediation', ref = '$DSMEDIATION_VERSION', repos = c('https://cloud.r-project.org', 'https://cran.datashield.org'), upgrade = FALSE, lib = '$ROCK_LIB')" && \
    Rscript -e "remotes::install_github('transbioZI/dsMTLBase', ref = '$DSMTL_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
    Rscript -e "remotes::install_github('datashield/dsSurvival', ref = '$DSSURVIVAL_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
    Rscript -e "remotes::install_github('molgenis/ds-tidyverse', ref = '$DSTIDYVERSE_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
    Rscript -e "remotes::install_github('isglobal-brge/dsExposome', ref = '$DSEXPOSOME_VERSION', repos = c('https://cloud.r-project.org', 'https://cran.datashield.org'), upgrade = FALSE, lib = '$ROCK_LIB')" && \
    Rscript -e "remotes::install_github('isglobal-brge/dsOmics', ref = '$DSOMICS_VERSION', upgrade = FALSE, lib = '$ROCK_LIB')" && \
    Rscript -e "remotes::install_github('datashield/dsBase', ref = '$DSBASE_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
    # Clean up temporary files and caches to reduce image size
    rm -rf /tmp/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /root/.cache/R && \
    Rscript -e "if (file.exists('/tmp/downloaded_packages')) unlink('/tmp/downloaded_packages', recursive = TRUE)" && \
    # Remove examples directories from installed R packages to reduce image size
    find $ROCK_LIB -type d -name "examples" -exec rm -rf {} + 2>/dev/null || true && \
    # Set proper ownership
    chown -R rock $ROCK_LIB

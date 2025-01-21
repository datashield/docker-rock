#
# Rock R Server Dockerfile with DataSHIELD Lemon Donkey profile
#
# https://github.com/datashield/docker-rock
#

# R 4.4.2, Rock 2.1.1
FROM datashield/rock-base:6.3.1-R4.4.2

ENV DSMEDIATION_VERSION=0.0.3
ENV DSEXPOSOME_VERSION=2.0.9
ENV DSTIDYVERSE_VERSION=v1.0.1
ENV DSOMICS_VERSION=v1.0.18-2
ENV DSMTL_VERSION=0.9.9
ENV DSSURVIVAL_VERSION=v2.1.3
ENV DSBASE_VERSION=6.3.1

ENV ROCK_LIB=/var/lib/rock/R/library

# Install new R packages
# dsMediation
RUN Rscript -e "remotes::install_github('datashield/dsMediation', ref = '$DSMEDIATION_VERSION', repos = c('https://cloud.r-project.org', 'https://cran.datashield.org'), upgrade = FALSE, lib = '$ROCK_LIB')"
# dsMTLBase
RUN Rscript -e "remotes::install_github('transbioZI/dsMTLBase', ref = '$DSMTL_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')"
# dsSurvival
RUN Rscript -e "remotes::install_github('datashield/dsSurvival', ref = '$DSSURVIVAL_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')"
# dsTidyverse
RUN Rscript -e "remotes::install_github('molgenis/ds-tidyverse', ref = '$DSTIDYVERSE_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')"
# dsExposome
RUN Rscript -e "BiocManager::install(c('bumphunter', 'missMethyl', 'rexposome'), update = FALSE, ask = FALSE, lib = '$ROCK_LIB')" \
 && Rscript -e "remotes::install_github('isglobal-brge/dsExposome', ref = '$DSEXPOSOME_VERSION', repos = c('https://cloud.r-project.org', 'https://cran.datashield.org'), upgrade = FALSE, lib = '$ROCK_LIB')"
# dsOmics
RUN Rscript -e "BiocManager::install(c('Biobase', 'SNPRelate', 'GENESIS', 'GWASTools', 'GenomicRanges', 'SummarizedExperiment', 'DESeq2', 'edgeR', 'MEAL'), update = FALSE, ask = FALSE, lib = '$ROCK_LIB')" \
 && Rscript -e "remotes::install_github('isglobal-brge/dsOmics', ref = '$DSOMICS_VERSION', upgrade = FALSE, lib = '$ROCK_LIB')"
# dsBase
RUN Rscript -e "remotes::install_github('datashield/dsBase', ref = '$DSBASE_VERSION', dependencies = TRUE, upgrade = FALSE, lib = '$ROCK_LIB')" && \
  chown -R rock $ROCK_LIB

rock_lib <- Sys.getenv("ROCK_LIB")

repos <- c(
  CRAN = "https://cloud.r-project.org",
  DataShield = "https://cran.datashield.org"
)

options(repos = repos)
Sys.setenv(PAK_SYSREQS = "false")

# pak installeren indien nog niet aanwezig
if (!requireNamespace("pak", quietly = TRUE)) {
  install.packages(
    "pak",
    repos = "https://cloud.r-project.org",
    lib = rock_lib
  )
}

.libPaths(c(rock_lib, .libPaths()))

# GitHub packages
pak::pkg_install(
  c(
    sprintf(
      "github::datashield/dsMediation@%s",
      Sys.getenv("DSMEDIATION_VERSION")
    ),
    sprintf(
      "github::transbioZI/dsMTLBase@%s",
      Sys.getenv("DSMTL_VERSION")
    ),
    sprintf(
      "github::datashield/dsSurvival@%s",
      Sys.getenv("DSSURVIVAL_VERSION")
    ),
    sprintf(
      "github::molgenis/ds-tidyverse@%s",
      Sys.getenv("DSTIDYVERSE_VERSION")
    ),
    sprintf(
      "github::isglobal-brge/dsExposome@%s",
      Sys.getenv("DSEXPOSOME_VERSION")
    ),
    sprintf(
      "github::isglobal-brge/dsOmics@%s",
      Sys.getenv("DSOMICS_VERSION")
    ),
    sprintf(
      "github::datashield/dsBase@%s",
      Sys.getenv("DSBASE_VERSION")
    )
  ),
  lib = rock_lib
)

# Bioconductor packages in één call
BiocManager::install(
  c(
    "bumphunter",
    "missMethyl",
    "rexposome",
    "Biobase",
    "SNPRelate",
    "GENESIS",
    "GWASTools",
    "GenomicRanges",
    "SummarizedExperiment",
    "DESeq2",
    "edgeR",
    "MEAL"
  ),
  update = FALSE,
  ask = FALSE,
  lib = rock_lib
)

# docker-rock-base

[Rock R server](https://www.obiba.org/pages/products/rock/) with DataSHIELD packages inside:

* [datashield/dsBase](https://github.com/datashield/dsBase)
* [molgenis/ds-tidyverse](https://github.com/molgenis/ds-tidyverse) (dsTidyverse)
* [obiba/resourcer](https://github.com/obiba/resourcer)

The `-native` tagged images are based on the [Rock native executable](https://github.com/obiba/docker-rock) variant (no Java runtime): build with `--build-arg VARIANT=-native`.

## Release

Images are built and published to Docker Hub by GitHub Actions when a tag matching `rock-base-<base-version>-R<r-version>[-native]` is pushed, e.g. `rock-base-6.3.5-R4.6.1`.

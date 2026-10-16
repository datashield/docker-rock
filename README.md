# docker-rock-base

[Rock R server](https://www.obiba.org/pages/products/rock/) with DataSHIELD packages inside:

* [datashield/dsBase](https://github.com/datashield/dsBase)
* [obiba/resourcer](https://github.com/obiba/resourcer)

The `-native` tagged images are based on the [Rock native executable](https://github.com/obiba/docker-rock) variant (no Java runtime): build with `--build-arg VARIANT=-native`.

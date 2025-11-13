#
# Rock R Server Dockerfile with DataSHIELD Quebrada Lamda profile
#
# https://github.com/datashield/docker-rock
#

# R 4.5.2, Rock 2.1.6
FROM datashield/rock-base:6.3.4-R4.5.2

ENV ROCK_LIB=/var/lib/rock/R/library

# Update of packages
RUN apt-get update -y; apt-get upgrade -y; apt-get autoremove -y

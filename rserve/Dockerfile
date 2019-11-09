FROM rocker/r-ver:3.6

ARG RS_VERSION
ENV RS_VERSION=${RS_VERSION:-1.8-6}

## install rserve
RUN apt-get update && apt-get install -y libssl-dev wget libhiredis-dev
RUN wget http://www.rforge.net/Rserve/snapshot/Rserve_${RS_VERSION}.tar.gz \
    && R CMD INSTALL Rserve_${RS_VERSION}.tar.gz

## install jsonlite
RUN R -e "install.packages('jsonlite', 'futile.logger')"

## create a user
RUN useradd api && mkdir /home/api \
    && chown api:api /home/api

USER api
WORKDIR /home/api

## copy source
COPY . /home/api/

ENTRYPOINT ["/usr/local/bin/R", "CMD", "Rserve"]
CMD ["--slave", "--RS-conf", "/home/api/rserve.conf", "--RS-source", "/home/api/rserve-src.R"]
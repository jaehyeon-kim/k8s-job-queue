FROM rocker/r-ver:3.6

ARG RS_VERSION
ENV RS_VERSION=${RS_VERSION:-1.8-6}

## install rserve
RUN apt-get update \
    && apt-get install -y libssl-dev libhiredis-dev wget
RUN wget http://www.rforge.net/Rserve/snapshot/Rserve_${RS_VERSION}.tar.gz \
    && R CMD INSTALL Rserve_${RS_VERSION}.tar.gz

## install jsonlite
RUN R -e "install.packages(c('jsonlite', 'futile.logger', 'redux', 'RSclient'))"

## create a user
RUN useradd app && mkdir /home/app \
    && chown app:app /home/app

USER app
WORKDIR /home/app

## copy source
COPY . /home/app/

ENTRYPOINT ["/usr/local/bin/R", "CMD", "Rserve"]
CMD ["--slave", "--RS-conf", "/home/app/rserve.conf", "--RS-source", "/home/app/rserve-src.R"]
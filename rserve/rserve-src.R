library(redux)
library(jsonlite)
library(futile.logger)

source('./process-req.R')
source('./src/jobs.R')


RR(check_conn_only = TRUE)

.http.request <- process_request

flog.info("API is ready to serve requests...")

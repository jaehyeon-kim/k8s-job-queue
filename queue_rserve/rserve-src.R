library(RSclient)
library(redux)
library(jsonlite)
library(futile.logger)

source('./process-req.R')
source('./tasks.R')

.http.request <- process_request

flog.info("API is ready to serve requests...")

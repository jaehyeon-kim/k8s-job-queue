library(redux)
library(jsonlite)
library(futile.logger)

source('./process-req.R')
source('./src/jobs.R')

redis_host <- Sys.getenv('REDID_HOST', 'localhost')
redis_port <- Sys.getenv('REDID_PORT', '6379')
redis_db <- Sys.getenv('REDIS_DB', '1')

## check if redis is available
is_redis_available = {
  is_available = redis_available(host=redis_host, port=redis_port, db=redis_db)
  info <- sprintf('host %s, port %s, db %s', redis_host, redis_port, redis_db)
  if (is_available) {
    flog.info(sprintf('Redis is available - %s', info))
  } else {
    flog.error(sprintf('Redis is not available - %s', info))
  }
  is_available
}
stopifnot(exprs = is_redis_available)

## create an interface to redis
RR <- hiredis(host=redis_host, port=redis_port, db=redis_db)

.http.request <- process_request

flog.info("API is ready to serve requests...")

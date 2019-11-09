RR <- function(check_conn_only = FALSE) {
  redis_host <- Sys.getenv('REDID_HOST', 'localhost')
  redis_port <- Sys.getenv('REDID_PORT', '6379')
  redis_db <- Sys.getenv('REDIS_DB', '1')
  info <- sprintf('host %s, port %s, db %s', redis_host, redis_port, redis_db)
  ## check if redis is available
  is_available = redis_available(host=redis_host, port=redis_port, db=redis_db)
  if (is_available) {
    flog.info(sprintf('Redis is available - %s', info))
  } else {
    flog.error(sprintf('Redis is not available - %s', info))
  }
  ## create an interface to redis
  if (!check_conn_only) {
    return(hiredis(host=redis_host, port=redis_port, db=redis_db))
  }
}


long_task <- function(task_id, total) {
  rr <- RR()
  for (i in seq.int(total)) {
    is_total <- i == max(seq.int(total))
    state <- if (is_total) 'SUCESS' else 'PROGRESS'
    msg <- sprintf("Percent completion %s", ceiling(i / total * 100))
    val <- list(state = state, current = i, total = total, status = msg)
    if (is_total) {
      val <- append(val, list(result = total))
    }
    flog.info(sprintf('task id: %s, message: %s', task_id, msg))
    rr$SET(task_id, val)
    Sys.sleep(1)
  }
}


get_task <- function(task_id) {
  rr <- RR()
  rr$GET(task_id)
}

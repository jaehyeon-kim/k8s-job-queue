RR <- function(check_conn_only = FALSE) {
  redis_host <- Sys.getenv("REDIS_HOST", "localhost")
  redis_port <- Sys.getenv("REDIS_PORT", "6379")
  redis_db <- Sys.getenv("REDIS_DB", "1")
  info <- sprintf("host %s, port %s, db %s", redis_host, redis_port, redis_db)
  ## check if redis is available
  is_available = redis_available(host=redis_host, port=redis_port, db=redis_db)
  if (is_available) {
    flog.info(sprintf("Redis is available - %s", info))
  } else {
    flog.error(sprintf("Redis is not available - %s", info))
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
    state <- if (is_total) "SUCESS" else "PROGRESS"
    msg <- sprintf("Percent completion %s ...", ceiling(i / total * 100))
    val <- list(state = state, current = i, total = total, status = msg)
    if (is_total) {
      val <- append(val, list(result = total))
    }
    flog.info(sprintf("task id: %s, message: %s", task_id, msg))
    rr$SET(task_id, object_to_bin(val))
    Sys.sleep(1)
  }
}


handle_long_task <- function(task_id, total) {
  flog.info(sprintf("task started, task_id - %s, total - %s", task_id, total))
  conn <- RS.connect()
  RS.eval(conn, library(redux))
  RS.eval(conn, library(futile.logger))
  RS.eval(conn, setwd("/home/app"))
  RS.eval(conn, source("./tasks.R"))
  RS.assign(conn, task_id)
  RS.assign(conn, total)
  RS.eval(conn, long_task(task_id, total), wait=FALSE, lazy=TRUE)
  RS.close(conn)
  flog.info(sprintf("task executed, task_id - %s, total - %s", task_id, total))
  list(task_id = task_id, status = "created")
}

get_task <- function(task_id) {
  rr <- RR()
  val <- bin_to_object(rr$GET(task_id))
  flog.info(sprintf("task id - %s", task_id))
  flog.info(val)
  val
}

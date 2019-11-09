long_task <- function(total) {
  msg <- ''
  for (i in seq.int(total)) {
    msg <- sprintf("Percent completion %s", ceiling(i / total * 100))
    print(msg)
    Sys.sleep(1)
  }
}

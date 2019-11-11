#### PROCESS REQUEST
process_request <- function(url, query, body, headers) {   
  #### building request object
  ## not strictly necessary as in FastRWeb, 
  ## just to make clear of request related variables
  request <- list(uri = url, method = 'POST', 
                  query = query, body = body)
  
  ## parse headers
  request$headers <- parse_headers(headers)
  if ("request-method" %in% names(request$headers)) 
    request$method <- c(request$headers["request-method"])
  
  ## parse parameters (function arguments)
  ## POST accept only 2 content types
  ## - application/x-www-form-urlencoded by built-in server
  ## - application/json
  ## used below as do.call(function_name, request$pars)
  request$pars <- list()
  if (request$method == 'POST') {
    if (!is.null(body)) {
      if (is.raw(body)) 
        body <- rawToChar(body)
      if (any(grepl('application/json', request$headers))) 
        body <- jsonlite::fromJSON(body)
      request$pars <- as.list(body)
    }
  } else {
    if (!is.null(query)) {
      request$pars <- as.list(query)
    }
  }
  
  #### building output object
  ## list(payload, content-type, headers, status_code)
  ## https://github.com/s-u/Rserve/blob/master/src/http.c#L358
  payload <- NULL
  content_type <- 'application/json; charset=utf-8'
  headers <- character(0)
  status_code <- 200
  
  ## generate payload (function output)
  ## function name must match to resource path for now
  matched_fun <- gsub('^/', '', request$uri)
  
  ## no resource path means no matching function
  if (matched_fun == '') {
    payload <- list(api_version = '1.0')
    if (grepl('application/json', content_type)) 
      payload <- jsonlite::toJSON(payload, auto_unbox = TRUE)
    return (list(payload, content_type, headers)) # default status 200
  }
  
  ## check if all defined arguments are supplied
  params = jsonlite::fromJSON(unlist(request$pars))
  defined_args <- formalArgs(matched_fun)[formalArgs(matched_fun) != '...']
  args_exist <- defined_args %in% names(params)
  if (!all(args_exist)) {
    missing_args <- defined_args[!args_exist]
    payload <- list(message = paste('Missing parameter -', 
                                    paste(missing_args, collapse = ', ')))
    status_code <- 400
  }
  
  if (is.null(payload)) {
    payload <- tryCatch({
      do.call(matched_fun, params)
    }, error = function(err) {
      print(err)
      list(message = 'Internal Server Error')
    })
  }
  
  if (grepl('application/json', content_type)) 
    payload <- jsonlite::toJSON(payload, auto_unbox = TRUE)
  
  return (list(payload, content_type, headers, status_code))
}

# parse headers in process_request()
# https://github.com/s-u/FastRWeb/blob/master/R/run.R#L65
parse_headers <- function(headers) {
  ## process headers to pull out request method (if supplied) and cookies
  if (is.raw(headers)) headers <- rawToChar(headers)
  if (is.character(headers)) {
    ## parse the headers into key/value pairs, collapsing multi-line values
    h.lines <- unlist(strsplit(gsub("[\r\n]+[ \t]+"," ", headers), "[\r\n]+"))
    h.keys <- tolower(gsub(":.*", "", h.lines))
    h.vals <- gsub("^[^:]*:[[:space:]]*", "", h.lines)
    names(h.vals) <- h.keys
    h.vals <- h.vals[grep("^[^:]+:", h.lines)]
    return (h.vals)
  } else {
    return (NULL)
  }
}
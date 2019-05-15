req_and_assign <- function(object, name) {
  req(object)
  assign(name, object, pos = 1L)
}

multiple_gsub <- function(object, terms) {
  for (term in terms) {
    object <- gsub(term[1], term[2], object)
  }
  
  return(object)
}

custom_try_catch <- function(expr) {
  warn <- err <- NULL
  
  withCallingHandlers(
    tryCatch(expr, error = function(e) {
      err <<- e
      NULL
    }), warning = function(w) {
      warn <<- w
      invokeRestart("muffleWarning")
    }
  )
  
  return(list(warning = warn, error = err))
}
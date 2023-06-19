op <- options(rbcb_cache = FALSE)

withr::defer(options(op), teardown_env())

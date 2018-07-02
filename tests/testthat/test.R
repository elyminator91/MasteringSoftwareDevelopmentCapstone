
context("Clean Data")

test_file <- eq_clean_data("./inst/extdata/dataset.txt")
tryCatch({
  expect_that(test_file, is_a("data.frame"))
  expect_that(dim(test_file), is_equivalent_to(c(3268, 7)))
  expect_that(colnames(test_file), is_equivalent_to(c("DATE", "LATITUDE", "LONGITUDE",
                                                      "COUNTRY", "LOCATION", 
                                                      "RICHTER_SCALE", "DEATH_COUNT")))
  expect_that(sapply(test_file, typeof), is_equivalent_to(c("double", "double", "double",
                                                            "character", "character",
                                                            "double", "double")))
  }, finally = {
    rm(test_file)
  })
  

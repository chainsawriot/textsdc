test_that("calculate_duplication with with dfm", {
    mc <- readRDS("../testdata/mediacloud_unima_dfm.RDS")
    expect_error(calculate_duplication(mc), NA)
    expect_error(calculate_duplication(mc, method = "jaccard"), NA)
    ## The following implies get_deduplicated_version is also working.
    expect_error(calculate_duplication(mc, return_text_only = TRUE, threshold = 0.6), NA)
})

test_that("print method", {
    mc <- readRDS("../testdata/mediacloud_unima_dfm.RDS")
    expect_error(x <- calculate_duplication(mc), NA)
    expect_error(outputtext <- capture_output(print(x), print = FALSE), NA)
    expect_true(grepl("^DFM of 88", outputtext))
})

test_that("", {
    mc <- readRDS("../testdata/mediacloud_unima_dfm.RDS")
    x <- calculate_duplication(mc)
    y <- get_deduplicated_version(x)
    expect_equal(quanteda::ndoc(y), 86) ## 88 - 2
})

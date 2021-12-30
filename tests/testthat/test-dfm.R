test_that("calculate_textsdc with with dfm", {
    mc <- readRDS("../testdata/mediacloud_unima_dfm.RDS")
    expect_error(calculate_textsdc(mc), NA)
    expect_error(calculate_textsdc(mc, method = "jaccard"), NA)
    ## The following implies clean_textsdc is also working.
    expect_error(calculate_textsdc(mc, return_text_only = TRUE, threshold = 0.6), NA)
})

test_that("print method", {
    mc <- readRDS("../testdata/mediacloud_unima_dfm.RDS")
    expect_error(x <- calculate_textsdc(mc), NA)
    expect_error(outputtext <- capture_output(print(x), print = FALSE), NA)
    expect_true(grepl("^DFM of 88", outputtext))
})

test_that("", {
    mc <- readRDS("../testdata/mediacloud_unima_dfm.RDS")
    x <- calculate_textsdc(mc)
    y <- clean_textsdc(x)
    expect_equal(quanteda::ndoc(y), 86) ## 88 - 2
})

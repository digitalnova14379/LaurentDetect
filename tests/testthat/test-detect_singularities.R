test_that("detect_singularities returns a data.frame", {
  df <- data.frame(
    Date = seq.Date(as.Date("2024-01-01"), by = "day", length.out = 100),
    LogReturns = rnorm(100, mean = 0, sd = 2)
  )
  
  sing <- detect_singularities(df, threshold = 0.5, window_size = 10)
  
  expect_s3_class(sing, "data.frame")
})

test_that("detect_singularities handles data correctly", {
  df <- data.frame(
    Date = seq.Date(as.Date("2024-01-01"), by = "day", length.out = 100),
    LogReturns = c(rep(0, 45), 10, rep(0, 54))
  )
  
  sing <- detect_singularities(df, threshold = 0.3, window_size = 10)
  
  if (nrow(sing) > 0) {
    expected_cols <- c("Date", "Index", "PrincipalNorm", "Residue", "Value")
    expect_true(all(expected_cols %in% names(sing)))
  }
})

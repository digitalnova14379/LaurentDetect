library(testthat)
library(LaurentDetect)
test_that("laurent_approximation works and returns expected structure", {

  # Données simulées
  set.seed(123)
  data <- rnorm(200)

  # Exécution
  laurent <- laurent_approximation(
    data,
    center_idx = 100,
    window_size = 20,
    n_neg = 3,
    n_pos = 5
  )

  # 1️⃣ Le résultat doit être une liste
  expect_type(laurent, "list")

  # 2️⃣ Les éléments attendus doivent exister
  expected_names <- c(
    "neg_coeffs", "const_coeff", "pos_coeffs",
    "principal_norm", "residue", "center_idx"
  )
  expect_true(all(expected_names %in% names(laurent)))

  # 3️⃣ Vérification des dimensions
  expect_length(laurent$neg_coeffs, 3)
  expect_length(laurent$pos_coeffs, 5)
  expect_length(laurent$const_coeff, 1)

  # 4️⃣ Types
  expect_true(is.numeric(laurent$neg_coeffs))
  expect_true(is.numeric(laurent$pos_coeffs))
  expect_true(is.numeric(laurent$const_coeff))
  expect_true(is.numeric(laurent$principal_norm))
  expect_true(is.numeric(laurent$residue))
  expect_equal(laurent$center_idx, 100)

  # 5️⃣ Norme du principal part >= 0
  expect_gte(laurent$principal_norm, 0)
})

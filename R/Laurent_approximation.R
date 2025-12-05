#' Compute Local Laurent Series Approximation
#'
#' Approximates a time series locally around a center point using Laurent series.
#'
#' @param data Numeric vector. Time series data
#' @param center_idx Integer. Index of the center point
#' @param window_size Integer. Number of points on each side of center
#' @param n_neg Integer. Number of negative power terms (principal part)
#' @param n_pos Integer. Number of positive power terms (regular part)
#'
#' @return A list containing:
#'   \item{neg_coeffs}{Coefficients of negative powers}
#'   \item{const_coeff}{Constant term}
#'   \item{pos_coeffs}{Coefficients of positive powers}
#'   \item{principal_norm}{Norm of the principal part (singularity indicator)}
#'   \item{residue}{Residue (coefficient of (t-t0)^{-1})}
#'   \item{center_idx}{Center index}
#'
#' @examples
#' \dontrun{
#' data <- rnorm(100)
#' laurent <- laurent_approximation(data, center_idx = 50)
#' print(laurent$principal_norm)
#' }
#'
#' @export
laurent_approximation <- function(data, center_idx, window_size = 20, n_neg = 3, n_pos = 5) {

  start_idx <- max(1, center_idx - window_size)
  end_idx <- min(length(data), center_idx + window_size)

  local_data <- data[start_idx:end_idx]
  t <- (start_idx:end_idx) - center_idx
  t[t == 0] <- 1e-10

  design_matrix <- matrix(NA, nrow = length(t), ncol = n_neg + n_pos + 1)

  for (k in 1:n_neg) {
    design_matrix[, k] <- t^(-n_neg + k - 1)
  }

  design_matrix[, n_neg + 1] <- 1

  for (k in 1:n_pos) {
    design_matrix[, n_neg + 1 + k] <- t^k
  }

  coeffs <- tryCatch({
    solve(t(design_matrix) %*% design_matrix) %*% t(design_matrix) %*% local_data
  }, error = function(e) {
    rep(0, n_neg + n_pos + 1)
  })

  neg_coeffs <- coeffs[1:n_neg]
  const_coeff <- coeffs[n_neg + 1]
  pos_coeffs <- coeffs[(n_neg + 2):(n_neg + n_pos + 1)]

  principal_part_norm <- sqrt(sum(neg_coeffs^2))
  residue <- neg_coeffs[n_neg]

  return(list(
    neg_coeffs = neg_coeffs,
    const_coeff = const_coeff,
    pos_coeffs = pos_coeffs,
    principal_norm = principal_part_norm,
    residue = residue,
    center_idx = center_idx
  ))
}

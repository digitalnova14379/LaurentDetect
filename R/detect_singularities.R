#' Detect Singularities in Financial Time Series
#'
#' Scans a time series for singularities using Laurent series approximation.
#'
#' @param df Data.frame with Date column and variable to analyze
#' @param variable Character. Name of column to analyze (default: 'LogReturns')
#' @param threshold Numeric. Threshold for principal part norm
#' @param window_size Integer. Window size for Laurent approximation
#'
#' @return Data.frame of detected singularities with columns:
#'   Date, Index, PrincipalNorm, Residue, Value
#'
#' @examples
#' \dontrun{
#' df <- load_financial_data('AAPL', '2024-01-01', Sys.Date())
#' sing <- detect_singularities(df, threshold = 0.5)
#' print(sing)
#' }
#'
#' @export
detect_singularities <- function(df, variable = 'LogReturns', threshold = 0.5, window_size = 20) {

  message('Detecting singularities...')

  data <- df[[variable]]
  n <- length(data)

  singularities <- data.frame()

  for (i in seq(window_size + 1, n - window_size, by = 5)) {

    laurent <- laurent_approximation(data, center_idx = i, window_size = window_size)

    if (laurent$principal_norm > threshold) {
      singularities <- rbind(singularities, data.frame(
        Date = df$Date[i],
        Index = i,
        PrincipalNorm = laurent$principal_norm,
        Residue = laurent$residue,
        Value = data[i]
      ))
    }
  }

  message('Detected: ', nrow(singularities), ' singularities')

  return(singularities)
}

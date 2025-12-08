#' Load Financial Data from Yahoo Finance
#'
#' Downloads historical stock, crypto, or forex data and computes returns.
#'
#' @param symbol Character. Stock ticker symbol (e.g., 'AAPL', 'BTC-USD')
#' @param start_date Character. Start date in 'YYYY-MM-DD' format
#' @param end_date Character. End date in 'YYYY-MM-DD' format
#'
#' @return A data.frame with columns: Date, Close, Returns, LogReturns
#'
#' @examples
#' \dontrun{
#' df <- load_financial_data('AAPL', '2024-01-01', Sys.Date())
#' head(df)
#' }
#'
#' @export
#' @importFrom quantmod getSymbols Cl
#' @importFrom dplyr mutate lag filter
load_financial_data <- function(symbol, start_date = '2024-01-01', end_date = Sys.Date()) {

  message('Loading data for ', symbol, '...')

  data <- quantmod::getSymbols(symbol, src = 'yahoo', from = start_date,
                               to = end_date, auto.assign = FALSE)

  prices <- quantmod::Cl(data)

  df <- data.frame(
    Date = zoo::index(prices),
    Close = as.numeric(prices)
  )

  df <- dplyr::mutate(df,
    Returns = (Close - dplyr::lag(Close)) / dplyr::lag(Close) * 100,
    LogReturns = log(Close / dplyr::lag(Close)) * 100
  )
  df <- dplyr::filter(df, !is.na(Returns))

  message('Data loaded: ', nrow(df), ' observations')

  return(df)
}

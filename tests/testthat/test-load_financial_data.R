library(testthat)
library(LaurentDetect)


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

# ================================
#   FUNCTION : load_financial_data
# ================================

load_financial_data <- function(symbol,
                                start_date = '2024-01-01',
                                end_date   = Sys.Date()) {

  # Message affiché dans la console
  message('Loading data for ', symbol, '...')

  # Téléchargement des données financières depuis Yahoo Finance
  data <- quantmod::getSymbols(symbol,
                               src = 'yahoo',
                               from = start_date,
                               to   = end_date,
                               auto.assign = FALSE)

  # Extraction des prix de clôture
  prices <- quantmod::Cl(data)

  # Création d’un data.frame propre avec Date + Close
  df <- data.frame(
    Date  = zoo::index(prices),   # Index du xts (dates)
    Close = as.numeric(prices)    # Prix de clôture en numeric
  )

  # Calcul des rendements simples et logarithmiques
  df <- df %>%
    dplyr::mutate(
      Returns    = (Close - dplyr::lag(Close)) / dplyr::lag(Close) * 100,
      LogReturns = log(Close / dplyr::lag(Close)) * 100
    ) %>%
    dplyr::filter(!is.na(Returns))  # Suppression de la première ligne NA

  # Message final
  message('Data loaded: ', nrow(df), ' observations')

  # Retourne les données
  return(df)
}

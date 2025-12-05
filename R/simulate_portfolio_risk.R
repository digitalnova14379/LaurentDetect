#' Simulate Portfolio Impact of Singularities
#'
#' Simulates how detected singularities affect portfolio value.
#'
#' @param df Data.frame of financial data
#' @param singularities Data.frame of detected singularities
#' @param initial_capital Numeric. Starting capital (default: 10000)
#' @param risk_factor Numeric. Risk adjustment at singularities (default: 0.05)
#'
#' @return Data.frame with portfolio simulation
#'
#' @examples
#' \dontrun{
#' df <- load_financial_data('AAPL', '2024-01-01', Sys.Date())
#' sing <- detect_singularities(df)
#' portfolio <- simulate_portfolio_risk(df, sing)
#' }
#'
#' @export
#' @importFrom dplyr mutate filter lag summarise
simulate_portfolio_risk <- function(df, singularities, initial_capital = 10000, risk_factor = 0.05) {

  message('Simulating portfolio impact...')

  portfolio <- df %>%
    dplyr::mutate(
      IsSingularity = Date %in% singularities$Date,
      AdjustedReturns = ifelse(IsSingularity, Returns * (1 - risk_factor), Returns),
      PortfolioValue = initial_capital * cumprod(1 + AdjustedReturns / 100)
    )

  losses <- portfolio %>%
    dplyr::filter(IsSingularity) %>%
    dplyr::mutate(Loss = (Returns - AdjustedReturns) / 100 * dplyr::lag(PortfolioValue)) %>%
    dplyr::summarise(TotalLoss = sum(Loss, na.rm = TRUE))

  message('Estimated total loss at singularities: $', round(losses$TotalLoss, 2))

  return(portfolio)
}

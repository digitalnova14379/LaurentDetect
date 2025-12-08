#' Visualize Detected Singularities
#'
#' Creates a time series plot with singularities highlighted.
#'
#' @param df Data.frame of financial data
#' @param singularities Data.frame of detected singularities
#' @param variable Character. Variable to plot
#' @param title Character. Plot title
#'
#' @return A ggplot object
#'
#' @examples
#' \dontrun{
#' df <- load_financial_data('AAPL', '2024-01-01', Sys.Date())
#' sing <- detect_singularities(df)
#' plot_singularities(df, sing)
#' }
#'
#' @export
#' @import ggplot2
plot_singularities <- function(df, singularities, variable = 'LogReturns',
                               title = 'Financial Singularities Detection') {

  p <- ggplot2::ggplot(df, ggplot2::aes(x = Date, y = .data[[variable]])) +
    ggplot2::geom_line(color = 'steelblue', linewidth = 0.7) +
    ggplot2::geom_point(data = singularities, ggplot2::aes(x = Date, y = Value),
                        color = 'red', size = 3, shape = 17) +
    ggplot2::geom_vline(data = singularities, ggplot2::aes(xintercept = Date),
                        color = 'red', linetype = 'dashed', alpha = 0.5) +
    ggplot2::labs(
      title = title,
      subtitle = paste(nrow(singularities), 'singularities detected via Laurent series'),
      x = 'Date',
      y = variable,
      caption = 'Red markers = Detected singularities (poles)'
    ) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = 'bold', size = 14),
      plot.subtitle = ggplot2::element_text(color = 'gray30')
    )

  return(p)
}

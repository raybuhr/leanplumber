#' Export All Data to CSV or JSON
#'
#' https://docs.leanplum.com/reference#get_api-action-exportdata
#'
#' Exports raw data to downloadable files. Data is split into roughly 256 MB files, and is not necessarily ordered.
#' Exports can be made in JSON or CSV format
#' For JSON format, each file contains 1 line per session, with each session JSON-encoded.
#' For CSV format, data is split into separate files for sessions, states, events, event parameters, and user attributes.
#'
#' @param start_date string - First date in range to include in PDT/PST format: YYYYmmdd. Example: 20140223.
#' @param end_date string - Last date in range to include in PDT/PST format: YYYYmmdd. Defaults to startDate if not provided. Example: 20140223.
#' @param export_format string - The format to export data. Can be either json or csv. Default: json.
#' @param api_version string - The version of the Leanplum API to use. The current version is 1.0.6.
#' @param app_id string - The application ID. To find yours, select your app in the navigation column, and click Edit Apps. Under Keys, click Show.
#' @param client_key string - The Data Export key for your Leanplum App.
#'
#' @return A http response parsed by httr and jsonlite
#' @export
lp_export_data <- function(
  start_date = Sys.Date() - 1,
  end_date = NULL,
  export_format = NULL,
  api_version = "1.0.6",
  app_id = Sys.getenv("LEANPLUM_APP_ID"),
  client_key = Sys.getenv("LEANPLUM_DATA_EXPORT") # data export key needed
) {
  start_date <- format(lubridate::parse_date_time(start_date, c("ymd", "mdy")), "%Y%m%d")
  if (!is.null(end_date)) {
    end_date <- format(lubridate::parse_date_time(end_date, c("ymd", "mdy")), "%Y%m%d")
  }
  resp <- httr::GET(url = "https://www.leanplum.com/api?action=exportData",
                    query = list(
                      appId = app_id,
                      clientKey = client_key,
                      apiVersion = api_version,
                      startDate = start_date,
                      endData = end_date,
                      exportFormat = export_format
                    ),
                    encode = "json"
  )
  return(jsonlite::fromJSON(httr::content(resp, "text"), simplifyVector = FALSE))
}
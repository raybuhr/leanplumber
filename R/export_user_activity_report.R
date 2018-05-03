#' Export User Activity Report
#'
#' https://docs.leanplum.com/reference#get_api-action-exportreport
#'
#' Exports statistics for user activity in your app just as in the Analytics tab of the dashboard
#' Report are over specified period of time.
#' Report data becomes available to export every 2 hours, and only for complete sessions.
#' You may only export report data 100 times per day per app.
#' Exports with invalid arguments do not count towards the limit.
#'
#' @param event_names character vector of the events to be included in the report. Example: c\\("Add to cart", "Purchase"\\)
#' @param start_date string - First date in range to include in PDT/PST format: YYYYmmdd. Example: 20140223.
#' @param end_date string - Last date in range to include in PDT/PST format: YYYYmmdd. Defaults to startDate if not provided. Example: 20140223.
#' @param api_version string - The version of the Leanplum API to use. The current version is 1.0.6.
#' @param app_id string - The application ID. To find yours, select your app in the navigation column, and click Edit Apps. Under Keys, click Show.
#' @param client_key string - The Data Export key for your Leanplum App.
#'
#' @return A http response parsed by httr and jsonlite
#' @export
lp_export_user_activity_report <- function(
  event_names = NULL,
  start_date = Sys.Date() - 1,
  end_date = NULL,
  api_version = "1.0.6",
  app_id = Sys.getenv("LEANPLUM_APP_ID"),
  client_key = Sys.getenv("LEANPLUM_DATA_EXPORT")
) {
  start_date <- format(lubridate::parse_date_time(start_date, c("ymd", "mdy")), "%Y%m%d")
  if (!is.null(end_date)) {
    end_date <- format(lubridate::parse_date_time(end_date, c("ymd", "mdy")), "%Y%m%d")
  }
  if (!is.null(event_names)) {
    event_names <- jsonlite::toJSON(event_names)
  }
  resp <- httr::GET(url = "https://www.leanplum.com/api?action=exportReport",
              query = list(
                appId = app_id,
                clientKey = client_key,
                apiVersion = api_version,
                startDate = start_date,
                endData = end_date,
                dataType = "UserActivity",
                eventNames = event_names
              ),
              encode = "json"
  )
  return(jsonlite::fromJSON(httr::content(resp, "text"), simplifyVector = FALSE))
}
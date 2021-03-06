#' Export results retrieves the result of an export job generated by: exportData, exportReport, and exportUsers.
#'
#' https://docs.leanplum.com/reference#get_api-action-exportusers
#'
#' Retrieves the result of an export job generated by:
#' exportData, exportReport, and exportUsers.
#' This method requires your data export API clientKey.
#'
#' @param job_id string - The export job ID.
#' @param api_version string - The version of the Leanplum API to use. The current version is 1.0.6.
#' @param app_id string - The application ID. To find yours, select your app in the navigation column, and click Edit Apps. Under Keys, click Show.
#' @param client_key string - The Data Export key for your Leanplum App.
#'
#' @return A http response parsed by httr and jsonlite
#' @export
lp_get_export_results <- function(
  job_id,
  api_version = "1.0.6",
  app_id = Sys.getenv("LEANPLUM_APP_ID"),
  client_key = Sys.getenv("LEANPLUM_DATA_EXPORT")
) {
  resp <- httr::GET(url = "https://www.leanplum.com/api?action=getExportResults",
                    query = list(
                      appId = app_id,
                      clientKey = client_key,
                      apiVersion = api_version,
                      jobId = job_id
                    ),
                    encode = "json"
  )
  return(jsonlite::fromJSON(httr::content(resp, "text"), simplifyVector = FALSE))
}
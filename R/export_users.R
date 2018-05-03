#' Export Users exports multiple user IDs
#'
#' https://docs.leanplum.com/reference#get_api-action-exportusers
#'
#' Exports multiple user IDs.
#' This may be executed up to 10 times successfully per day.
#' This method requires your data export API clientKey.
#' Use getExportResults with the returned jobId to get the results.
#'
#' @param segment string - Limit export to only users that match the segment. The syntax is identical to that produced by the "Insert Value" feature on the dashboard.
#' @param ab_test_id integer - Limit export to only users that are in the given A/B test. The output will include the variant ID and name for each user.
#' @param api_version string - The version of the Leanplum API to use. The current version is 1.0.6.
#' @param app_id string - The application ID. To find yours, select your app in the navigation column, and click Edit Apps. Under Keys, click Show.
#' @param client_key string - The Data Export key for your Leanplum App.
#'
#' @return A http response parsed by httr and jsonlite
#' @export
lp_export_users <- function(
  segment = NULL,
  ab_test_id = NULL,
  api_version = "1.0.6",
  app_id = Sys.getenv("LEANPLUM_APP_ID"),
  client_key = Sys.getenv("LEANPLUM_DATA_EXPORT")
) {
  resp <- httr::GET(url = "https://www.leanplum.com/api?action=exportUsers",
                    query = list(
                      appId = app_id,
                      clientKey = client_key,
                      apiVersion = api_version,
                      segment = segment,
                      abTestId = ab_test_id
                    ),
                    encode = "json"
  )
  return(jsonlite::fromJSON(httr::content(resp, "text"), simplifyVector = FALSE))
}
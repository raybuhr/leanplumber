#' Gets information about all the messages for a given app
#'
#' https://docs.leanplum.com/reference#get_api-action-getmessages
#'
#' A successful response will return a list of messages.
#'
#' @param include_drafts string - Include drafts and unpublished changes. Default: false.
#' @param recent string - Only return information about active or recently finished messages. Default: true.
#' @param api_version string - The version of the Leanplum API to use. The current version is 1.0.6.
#' @param app_id string - The application ID. To find yours, select your app in the navigation column, and click Edit Apps. Under Keys, click Show.
#' @param client_key string - The Read-only Content key for your Leanplum App.
#'
#' @return A http response parsed by httr and jsonlite
#' @export
lp_get_messages <- function(
  include_drafts = "false",
  recent = "true",
  api_version = "1.0.6",
  app_id = Sys.getenv("LEANPLUM_APP_ID"),
  client_key = Sys.getenv("LEANPLUM_READ_CONTENT")
) {
  resp <- httr::GET(url = "https://www.leanplum.com/api?action=getMessages",
                    query = list(
                      appId = app_id,
                      clientKey = client_key,
                      apiVersion = api_version,
                      recent = recent,
                      includeDrafts = include_drafts
                    ),
                    encode = "json"
  )
  return(jsonlite::fromJSON(httr::content(resp, "text"), simplifyVector = FALSE))
}
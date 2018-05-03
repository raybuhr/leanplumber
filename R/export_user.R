#' Export user retrieves attributes for a single user
#'
#' https://docs.leanplum.com/reference#get_api-action-exportuser
#'
#' A successful request will return a map of the user's attributes, events and states.
#'
#' @param user_id string - The current user ID. You can set this to an email address or whatever you use at your company for user IDs. Leave it blank to use the device ID. For more info, see selecting a user.
#' @param device_id string - A unique ID for the device targeted by the request. You must provide a deviceId and/or a userId.
#' @param api_version string - The version of the Leanplum API to use. The current version is 1.0.6.
#' @param app_id string - The application ID. To find yours, select your app in the navigation column, and click Edit Apps. Under Keys, click Show.
#' @param client_key string - The Data Export key for your Leanplum App.
#'
#' @return A http response parsed by httr and jsonlite
#' @export
lp_get_user_info <- function(
  user_id,
  device_id = NULL,
  api_version = "1.0.6",
  app_id = Sys.getenv("LEANPLUM_APP_ID"),
  client_key = Sys.getenv("LEANPLUM_DATA_EXPORT")
) {
  # Retrieves attributes for the current user.
  # This method requires your data export API clientKey.
  resp <- httr::POST(url = "https://www.leanplum.com/api?action=exportUser",
                     body = list(
                       appId = app_id,
                       clientKey = client_key,
                       apiVersion = api_version,
                       userId = user_id,
                       deviceId = device_id
                     ),
                     encode = "json"
  )
  return(jsonlite::fromJSON(httr::content(resp, "text"), simplifyVector = FALSE))
}
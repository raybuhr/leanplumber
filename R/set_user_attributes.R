#' Sets user attributes for the user given by userId and/or deviceId.
#'
#' https://docs.leanplum.com/reference#post_api-action-setuserattributes
#'
#' Sets user attributes for the user given by userId and/or deviceId.
#' If the user has an open session, the attributes for the current session will also be updated.
#' Attributes will then propagate on data going forward.
#' User properties not supplied in this method will not be affected.
#' If the user/device does not exist, a new user will be created.
#'
#' @param user_id string - The current user ID. You can set this to an email address or whatever you use at your company for user IDs. Leave it blank to use the device ID. For more info, see selecting a user.
#' @param user_attributes object - A map of user attributes as key-value pairs. Each key must be a string. Attributes are saved across sessions. Only supplied attributes will be updated i.e., if you omit an existing attribute, it will be preserved. Example: \\{"gender":"F","age":21\\}.
#' @param api_version string - The version of the Leanplum API to use. The current version is 1.0.6.
#' @param app_id string - The application ID. To find yours, select your app in the navigation column, and click Edit Apps. Under Keys, click Show.
#' @param client_key string - The Production key for your Leanplum App.
#'
#' @return A http response parsed by httr and jsonlite
#' @export
lp_update_user_attributes <- function(user_id, user_attributes,
                                      api_version = "1.0.6",
                                      app_id = Sys.getenv("LEANPLUM_APP_ID"),
                                      client_key = Sys.getenv("LEANPLUM_PRODUCTION")) {

  resp <- httr::POST(url = "https://www.leanplum.com/api?action=setUserAttributes",
                     body = list(
                       appId = app_id,
                       clientKey = client_key,
                       apiVersion = api_version,
                       userId = user_id,
                       userAttributes = user_attributes
                     ),
                     encode = "json"
  )
  return(jsonlite::fromJSON(httr::content(resp, "text"), simplifyVector = FALSE))
}
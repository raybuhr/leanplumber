# leanplumber

A thin http client wrapper for the [Leanplum API](https://docs.leanplum.com/reference)

## Description

The leanplumber package provides a simple interface in R to Leanplum's API.

## Installation

```r
devtools::install_github('raybuhr/leanplumber')
```

## Details

I recommend that you start with the official documentation at [https://docs.leanplum.com/reference#introduction](https://docs.leanplum.com/reference#introduction). 

This package makes it a bit easier to send data to Leanplum, as well as export data. 
The Leanplum API endpoints and functions currently supported by this package include: 

* exportData - Exports All Data to CSV or JSON 
* exportReport - Exports statistics for user activity, messages, and A/B tests 
* exportUser - Get information about a specific user 
* exportUsers - Get a list of all userIds that match a condition 
* setUserAttributes - Insert and/or update unique attributes as a key-value map 
* getMessages - Get a list of all active messages

## Issues

Report bugs at [https://github.com/raybuhr/leanplumber/issues](http://github.com/raybuhr/leanplumber/issues)

## Examples

Export all data for a single day to a local JSON file

```r
# Export to JSON ----------------------------------------------------------
start_date <- as.Date("2018-03-17")

export_req <- lp_export_data(start_date = start_date, export_format = "json")
done <- FALSE

while (!done) {
  results_req <- lp_get_export_results(export_req$response[[1]]$jobId)
  if (results_req$response[[1]]$state != "FINISHED") {
    print("Still Running...")
    Sys.sleep(10)
  } else {
    print("Done!")
    done <- TRUE
  }
}

# download the file
system2(
  command = "wget",
  args = c(results_req$response[[1]]$files[[1]],
           "-O",
           paste0("leanplum_data_export_", format(start_date, "%Y%m%d"), ".json"))
)
```

Export all data for a single day to multiple local CSV files

```r
# Export to CSV -----------------------------------------------------------

export_req <- lp_export_data(start_date = start_date, export_format = "csv")
done <- FALSE

while (!done) {
  results_req <- lp_get_export_results(export_req$response[[1]]$jobId)
  if (results_req$response[[1]]$state != "FINISHED") {
    print("Still Running...")
    Sys.sleep(10)
  } else {
    print("Done!")
    done <- TRUE
  }
}


get_file_name <- function(response_file_url) {
  in_name <- str_extract(response_file_url, "output*([^\n\r]*)-")
  tmp_name <- gsub("output", "", in_name)
  out_name <- gsub("-", "", tmp_name)
  return(out_name)
}

walk(results_req$response[[1]]$files, function(x) {
  system2(command = "wget",
          args = c(x, "-O",
                   paste0("leanplum_data_export_", format(start_date, "%Y%m%d"), "_", get_file_name(x), ".csv"))
)
})
```

Get a dataframe of messages active and match up the "events" CSV downloaded from the above snippet. 

```r
# Get Message Names -------------------------------------------------------

message_names <- lp_get_messages(recent = "false")
message_name_df <- message_names[["response"]][[1]][["messages"]] %>%
  map(function(x)
    as.data.frame(x, row.names = FALSE, stringsAsFactors = FALSE)) %>%
  bind_rows()

message_events <- read_csv("leanplum_data_export_20180317_events.csv") %>%
  mutate(is_message_event = str_detect(eventName, "\\.m")) %>%
  filter(is_message_event) %>%
  mutate(message_id = as.numeric(str_extract(eventName, "([0-9]+)"))) %>%
  left_join(message_name_df, by = c("message_id" = "id"))

message_events %>%
  group_by(name, eventName) %>%
  summarise(values = n())
```

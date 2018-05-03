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

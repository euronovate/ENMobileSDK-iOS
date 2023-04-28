## ENSoftServer

![](https://badgen.net/badge/stable/1.3.0/blue)

## COCOAPODS

Add `pod 'ENSoftServer', '1.3.0'` to your **PodFile**

Communication between SDK and SoftServer webserver.

## Basic usage

In this module, is required an `ENSoftServerConfig` parameter, with this declaration:

```swift
public struct ENSoftServerConfig {
 var baseURL: String
 var licenseCode: String
 var userID: String
}
```

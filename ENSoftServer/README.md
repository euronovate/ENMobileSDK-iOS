## ENSoftServer

![](https://badgen.net/badge/stable/1.0.1/blue)

## COCOAPODS

Add `pod 'ENSoftServer', '1.0.1'` to your **PodFile**

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

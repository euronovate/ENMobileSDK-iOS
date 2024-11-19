
# DigitalSignage

#### [View Releases and Changelogs](https://github.com/euronovate/ENMobileSDK-iOS)

# Setup

Clone the repository and open the Example folder with Xcode.

Run `pod install` and open the `.xcworkspace` file. The project is then set up with one application module for the SDK feature.

Open DigitalSignage module, and in `Configuration.swift` replace:

```swift
static let digitalSignageUrl = "replace with digitalSignageUrl"
static let digitalSignageLicenseCode = "replace with digitalSignageLicenseCode"
static let enauthUrl = "replace with enauthUrl"
static let licenseKey = "replace with licenseKey"
static let jwt = "replace with jwt"
```

with the values provided by Euronovate.

To try the SDK a license is mandatory:
- online license: set the `licenseKey` / `enauthUrl`
- offline license: set the `jwt`

# Features

This demo uses:

- ENDigitalSignage
- ENPDFMiddleware
- ENViewer

A user can start:
- Local digital signage: with images taken from app assets.
- Remote digital signage: a working digital signage server is required, and its URL and license must be set up in the parameters above.

By double-tapping on the digital signage screen, an example document can be shown in read-only mode with the viewer.


# MultiLayoutViewerSignatureBox

#### [View Releases and Changelogs](https://github.com/euronovate/ENMobileSDK-iOS)

# Setup

Clone the repository and open the Example folder with Xcode.

Run `pod install` and open the `.xcworkspace` file. The project is then set up with one application module for the SDK feature.

Open MultiLayoutViewerSignatureBox module, and in `Configuration.swift` replace:

```swift
static var softServerConfig = ENSoftServerConfig(baseURL: "replace with baseURL",
                                                 licenseCode: "replace with license code",
                                                 userID: "replace with userID")

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
- ENPDFMiddleware'
- ENViewer'
- ENSignatureBox'
- ENBioLibrary'

A user can choose between multiple types of viewer and signature box, and then open a document to take a look at the layout selected.

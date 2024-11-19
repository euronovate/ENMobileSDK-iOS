
# DigitalSignagePubSubRemoteSignature

#### [View Releases and Changelogs](https://github.com/euronovate/ENMobileSDK-iOS)

# Setup

Clone the repository and open the Example folder with Xcode.

Run `pod install` and open the `.xcworkspace` file. The project is then set up with one application module for the SDK feature.

Open DigitalSignagePubSubRemoteSignature module, and in `Configuration.swift` replace:

```swift
static var pubSubConfig = DefaultPubSubConfig(url: "replace with url", 
                                              token: "replace with token", 
                                              pubSubServiceType: .signalR, 
                                              messagePath: ["arguments", "notificationData"])

static let digitalSignageUrl = "replace with digitalSignageUrl"
static let digitalSignageLicenseCode = "replace with digitalSignageLicenseCode"

static var softServerConfig = ENSoftServerConfig(baseURL: "replace with baseUrl",
                                                 licenseCode: "replace with licenseCode",
                                                 userID: "replace with userId")

static let enauthUrl = "replace with enauthUrl"
static let licenseKey = "replace with licenseKey"
static let jwt = "replace with jwt"
```

with the values provided by Euronovate.

To try the SDK a license is mandatory:
- online license: set the `licenseKey` / `enauthUrl`
- offline license: set the `jwt`

To try the features of this example also a SoftServer, Digital Signage and PubSub Server are required

# Features

This demo uses:

- ENDigitalSignage
- ENPDFMiddleware
- ENViewer
- ENSignatureBox
- ENBioLibrary
- ENPubSub

A user can start the Digital Signage and PubSub and then try a remote signature sending command messages via PubSub.

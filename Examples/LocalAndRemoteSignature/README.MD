
# LocalAndRemoteSignature

#### [View Releases and Changelogs](https://github.com/euronovate/ENMobileSDK-iOS)

# Setup

Clone the repository and open the Example folder with Xcode.

Run `pod install` and open the `.xcworkspace` file. The project is then set up with one application module for the SDK feature.

Open LocalAndRemoteSignature module, and in `Configure.swift` replace:

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

To try the local signature no further parameters are required, there is an example document and a development certificate for biometric data packed with the app.

To try the remote signature a working SoftServer is required.

# Features

This demo uses:

- ENDigitalSignage
- ENPDFMiddleware
- ENViewer
- ENSignatureBox
- ENBioLibrary

A user can try:
- The local signature with two APIs: a direct `openDocument(fromLocalSourceType: , fileName: )` function and the `event` API.
- The remote signature with two APIs: a direct `openDocumentAsync(fromGuid: )` function and the `event` API.
- The `DIALOGS` API that provides a dialog interface, styled as the SDK, to insert document GUIDs or to choose from a list of documents.
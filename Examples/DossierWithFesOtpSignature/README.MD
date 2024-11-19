
# DossierWithFesOtpSignature

#### [View Releases and Changelogs](https://github.com/euronovate/ENMobileSDK-iOS)

# Setup

Clone the repository and open the Example folder with Xcode.

Run `pod install` and open the `.xcworkspace` file. The project is then set up with one application module for the SDK feature.

Open DossierWithFesOtpSignature module, and in `Configuration.swift` replace:

```swift
static var softServerConfig = ENSoftServerConfig(baseURL: "replace with base url",
                                                 licenseCode: "replace with license code",
                                                 userID: "replace with user id")

static let enauthUrl = "replace with enauth url"
static let licenseKey = "replace with license key"
static let jwt = "replace with jwt"
```

with the values provided by Euronovate.

To try the SDK a license is mandatory:
- online license: set the `licenseKey` / `enauthUrl`
- offline license: set the `jwt`

To try the Dossier API and OTP signature, a working SoftServer is required. SoftServer must implement the OTP logic.

# Features

This demo uses:

- ENDigitalSignage
- ENPDFMiddleware
- ENViewer

A user can try:
- The Dossier API, given a working SoftServer with a valid dossier.
- The OTP FES Signature, given a dossier with at least one document.

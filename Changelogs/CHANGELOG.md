# Changelog

## v 1.3.8

- implementation of FES with OTP signature
- fix the management of default textfields and checkboxes
- better management of ABORT/CLOSE documents
- better management of textfields and checkboxes for already signed documents

## v 1.3.7

- refactor didSignDocument event: guid parameter name changed to documentGuid, add signatureName to identify the signatureImage

## v 1.3.6

- didSignDocument SDK carries the GUID of the document and the image (UIImage) of the newly applied signature

## v 1.3.5

- add custom FES and FEA type into signDocument/signLocalDocument events
- add custom watermark height and list of strings into signDocument/signLocalDocument events
- fix textfields and checkbox management

## v 1.3.4

- add support for Apple Silicon simulator

## v 1.3.3

- fix signatures priority check

## v 1.3.2

- update pdf viewer to 1.5.22 to fix checkbox rendering for 1x1 and 2x2 checkboxes
- update ENLibPdf to 2.3.1
- add signatures priority check
- add acrofields mandatory check

## v 1.3.1

-   fix LogServer events

## v 1.3.0

-   add Use Cases
-   add new configuration object for PDFMiddleware

## v 1.2.1

- Integrated ENLibPdf 2.1.6    
- improved online acrofield management
- PadES B-B signature
- Minor bugs fixed

## v 1.2.0

-  Optimized textbox, checkbox and signatures elaboration. 
- Bug fixes

## v 1.1.2

### ENSoftServer:

- Resolved a bug where hash and documentSize values weren't updated after acquire sign

## v 1.1.1

### ENSignatureBox:

- Added custom button labels for graphologist theme
- Removed clear signature on signatureBox errors

## v 1.1.0

### ENSignatureBox:

- Added fullscreen mode for signatureBox
- Added graphologist theme for signatureBox
- Added debug mode for signatureBox

## v 1.0.3

### Core:

- Added `appVersion` optional value in `ENMobileSDKConfig` to set a string and show it in both Viewer and DigitalSignage views.
- Added `considerAllSignatureFieldCharacters` bool value to consider all characters and not consider group special characters.
- Added new internal event `sdkInitialized` to know when the SDK is fully initialized.

### DigitalSignage:

- Optimized performances
- Fixed a bug which won't load new images if loaded while the application is in foreground.
- Added detail about appVersion (if set in core's config)

### ENSignatureBox

- Added new layout to show SignatureBox view.

### ENViewer

- Added new layout to show Viewer's buttons.
- Added detail about appVersion (if set in core's config)

## v 1.0.1

### Core:
- Added list document alert
- Added default theme Euronovate for layout
- Added check on `OAuth2` expiration
- Implemented retry call if first time returns `401`
- Added custom header and body datas for request OAuth2 token
- Added `keepScreenAlwaysOn flag`  in `ENMobileSDKConfig` to determine if force to keep screen always on or not.
- Added new events to `ENMobileSDKEvent`

### DigitalSignage:
- Added logic to accept local media to make offline playlist
- Added CTA event structs, to manage logic on how and when show alert in DigitalSignage screen
- Added example for DigitalSignage offline

### ENPDFProcessor
- Updated `ENLibPDF` to `2.0.1`

### ENPresenter
- Updated to version `1.5.11`

### ENPubSub
- Added `ReconnectionType` to manage retry reconnection on WebSocket.

### ENSignatureBox
- Updated `signatureImageConfig` with `watermarkReservedHeight` parameter.
- Added flag for `updateDocumentStatusOnDismiss`

### ENViewer
- Added `signFieldPlaceholder` struct to determine what to show as placeholder on signatureFields
- Added `idleTimeout` value and `viewDocumentAfterClose` to manage read-only document view.
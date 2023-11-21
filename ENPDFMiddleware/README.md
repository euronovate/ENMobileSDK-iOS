## ENPDFMiddleware

![](https://badgen.net/badge/stable/1.3.4/blue)

## COCOAPODS

Add `pod 'ENPDFMiddleware', '1.3.4'` to your **PodFile**

## Basic usage

As the name suggests, it's a middleware between local and online PDF management. Every PDF request passes here, and then it decides to pass it through [ENSoftServer module](ENSoftServer/README.md) or locally to [ENPDFProcessor module](ENPDFProcessor/README.md). Either if you request your pdf locally or from the server, you'll receive the same `PDFContainer`, which has every information required to show your PDF.

In build time, an `ENPDFMiddlewareConfig` must be provided.
This struct has 2 different parameters:

```swift
public let closeDocumentStatusOnConfirm: Bool
public let abortDocumentStatusOnCancel: Bool
```

If one of these variable is set to true, after a complete signature will be called a SoftServer endpoint to update document status.

Depending on the pdf source, you can call:

### PDF saved locally (through [ENPDFProcessor](ENPDFProcessor/README.md))

```swift
public func openDocument(fromLocalSourceType localSourceType: LocalSourceType, fileName: String, completion: @escaping (ENResponse<PDFContainer>) -> Void) {
```

A part from the file name, you can see the `localSourceType` param, which has this declaration:

```swift
public enum LocalSourceType {
 case unWritableUrl(url: URL)
 case writableUrl(url: URL)
}
```

This enum asks if the pdf is already in a writable location (for instance in `FileManager`), or in an unwritable location (available in `Bundle`). In the second case, to let the SDK to write and update the PDF, it's copied in a `FileManager` directory.

### PDF from GUID (through [ENSoftServer](ENSoftServer/README.md))

```swift
public func openDocument(fromGuid guid: String, completion: @escaping (ENResponse<PDFContainer>) -> Void) {
```

In this case the last one parameter to pass is the `documentGUID` received from SoftServer.

Other public functions are responsible to update signatures, checkboxes, textboxes and every editable field in PDF. These functions are called from [ENViewer](ENViewer/README.md) module.

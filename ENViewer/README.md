## ENViewer (conventionally ENCore)

![](https://badgen.net/badge/stable/1.0.1/blue)

## COCOAPODS

Add `pod 'ENViewer', '1.0.1'` to your **PodFile**

Module which let you see a PDF from either local source or SoftServer.

## Basic usage

Once you receive `PDFContainer` from `ENPDFMiddleware` module, call

```swift
public func present(pdfContainer: PDFContainer, json: String, in viewController: UIViewController)
```

You can find the `jsonString` param from `pdfContainer.structureModel.json`.
Be careful to call present function in `DispatchQueue.main.async` block.

## Advanced usage
`ENViewer` requires an `ENViewerConfig` inside its builder.

```swift
public struct ENViewerConfig {
    var signFieldPlaceholder: SignFieldPlaceholder
    var idleTimeout: Double?
    var viewDocumentAfterClose: Bool
}
```

`viewDocumentAfterClose` lets you see the document (in read-only mode) after it's been confirmed and closed. `idleTimeout` is a timer that when you are watching in read-only mode a document, if you don't touch anything it closes the document automatically.
`signFieldPlaceholder` is an enum that defines what show as placeholder for sign fields in a document.
```swift
public enum SignFieldPlaceholder {
	case signerName
	case defaultPlaceholder
	case customPlaceholder(text: String)
}
```

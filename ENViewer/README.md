## ENViewer (conventionally ENCore)

![](https://badgen.net/badge/stable/1.0.1/blue)

## COCOAPODS

Add `pod 'ENViewer'` to your **PodFile**

Module which let you see a PDF from either local source or SoftServer.

## Basic usage

Once you receive `PDFContainer` from `ENPDFMiddleware` module, call

```swift
public func present(pdfContainer: PDFContainer, json: String, in viewController: UIViewController)
```

You can find the `jsonString` param from `pdfContainer.structureModel.json`.
Be careful to call present function in `DispatchQueue.main.async` block.

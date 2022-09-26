## ENSignatureBox

![](https://badgen.net/badge/stable/1.1.0/blue)

## COCOAPODS

Add `pod 'ENSignatureBox', '1.1.0'` to your **PodFile**

## Basic usage

This modules let you draw on a canvas your signature with either pen or finger. The signatureBoxConfig is declared as below:

```swift
public struct ENSignatureBoxConfig {
	public init(signatureSourceType: ENSignatureSourceType, signatureImageConfig: ENSignatureImageConfig, useAlpha: Bool, signatureContentMode: ENSignatureContentMode, enableSignatureOverwrite: Bool,  updateDocumentStatusOnDismiss: Bool) {
		self.signatureSourceType = signatureSourceType
		self.signatureImageConfig = signatureImageConfig
		self.useAlpha = useAlpha
		self.signatureContentMode = signatureContentMode
		self.canEnableSignatureOverwrite = enableSignatureOverwrite,
		self.updateDocumentStatusOnDismiss = updateDocumentStatusOnDismiss
	}

 var signatureSourceType: ENSignatureSourceType
 public let signatureImageConfig: ENSignatureImageConfig
 public let useAlpha: Bool
 var signatureContentMode: ENSignatureContentMode
 public let canEnableSignatureOverwrite: Bool

}
```

- `signatureSourceType` defines which source is available for the signature, if `finger`, `Apple Pencil` or `Any`.
- `signatureImageConfig` is defined as follows:

```swift
public enum ENSignatureImageConfig {
    case justSignature
    case signatureAndSignerName(watermarkReservedHeight: CGFloat?)
    case signatureAndTimestamp(watermarkReservedHeight: CGFloat?)
    case signatureSignerNameAndTimestamp(watermarkReservedHeight: CGFloat?)
}
```

Depending on what you choose, you can see more or less details in rendered signature on the document. The variable `watermarkReservedHeight` is a value from between 0 and 1 which represents the height reserved to the additional infos. For example, if you set `0,4` as value, and the signatureField is height 100px, it means that the signerName, or the timestamp, fit 40px, and the signature image 60px.

- `signatureContentMode`:

```swift
public enum ENSignatureContentMode {
	case ignoreFieldRatio
	case keepFieldRatio
}
```

It defines the what ratio should be used in SignatureBox, if either keeping field ratio width and height, or using a default ratio. In second case it will center the signature image inside the field without stretching it.

- `updateDocumentStatusOnDismiss`: If true, when dismissed viewer it updates the document status.

`ENSignatureBox` is available in 2 different layouts, and you can try/set them by overriding default param `layoutType` in `ENViewerConfig`.

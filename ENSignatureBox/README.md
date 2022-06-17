## ENSignatureBox

![](https://badgen.net/badge/stable/1.0.1/blue)

## COCOAPODS

Add `pod 'ENSignatureBox'` to your **PodFile**

## Basic usage

This modules let you draw on a canvas your signature with either pen or finger. The signatureBoxConfig is declared as below:

```swift
public struct ENSignatureBoxConfig {
	public init(signatureSourceType: ENSignatureSourceType, signatureImageConfig: ENSignatureImageConfig, useAlpha: Bool, signatureContentMode: ENSignatureContentMode, enableSignatureOverwrite: Bool) {
		self.signatureSourceType = signatureSourceType
		self.signatureImageConfig = signatureImageConfig
		self.useAlpha = useAlpha
		self.signatureContentMode = signatureContentMode
		self.canEnableSignatureOverwrite = enableSignatureOverwrite
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
	case signatureAndSignerName
	case signatureAndTimestamp
	case signatureSignerNameAndTimestamp
}
```

Depending on what you choose, you can see more or less details in rendered signature on the document.

- `signatureContentMode`:

```swift
public enum ENSignatureContentMode {
	case ignoreFieldRatio
	case keepFieldRatio
}
```

It defines the what ratio should be used in SignatureBox, if either keeping field ratio width and height, or using a default ratio. In second case it will center the signature image inside the field without stretching it.

## ENSignatureBox

![](https://badgen.net/badge/stable/1.3.10/blue)

## COCOAPODS

Add `pod 'ENSignatureBox', '1.3.10'` to your **PodFile**

## Basic usage

This modules let you draw on a canvas your signature with either pen or finger. The signatureBoxConfig is declared as below:

```swift

var signatureSourceType: ENSignatureSourceType
public var signatureImageConfig: ENSignatureImageConfig
public let useAlpha: Bool
public var signatureContentMode: ENSignatureContentMode
public let canEnableSignatureOverwrite: Bool
public let layoutType: ENSignatureBoxType
public let showInFullScreen: Bool
public let minBioPackagesToAllowConfirmation: Int

public struct ENSignatureBoxConfig {
    public init(signatureSourceType: ENSignatureSourceType, signatureImageConfig: ENSignatureImageConfig, useAlpha: Bool, signatureContentMode: ENSignatureContentMode, enableSignatureOverwrite: Bool, layoutType: ENSignatureBoxType = .layout1, showInFullScreen: Bool = false, minBioPackagesToAllowConfirmation: Int = 1) {
		self.signatureSourceType = signatureSourceType
		self.signatureImageConfig = signatureImageConfig
		self.useAlpha = useAlpha
		self.signatureContentMode = signatureContentMode
		self.canEnableSignatureOverwrite = enableSignatureOverwrite,
		self.layoutType = layoutType
		self.showInFullScreen = showInFullScreen
        self.minBioPackagesToAllowConfirmation = minBioPackagesToAllowConfirmation
	}

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
    case keepFieldRatio
	case ignoreFieldRatio
}
```

It defines the ratio used in SignatureBox: 
- keep in SignatureBox the ratio width and height of the signature field
- ignore it using a default ratio to show to the user a wider Signature Box where is easier to do the signature. 
 
In the first case the SignatureBox could be smaller but the resulting signature image will fit perfectly into the signature field. In the last case the resulting signature image will be resized to fit into the signature field, and then centered, so the image could result smaller than in the first case.

- `ENSignatureBox` is available in 3 different layouts, and you can try/set them by overriding default param `layoutType` in `ENViewerConfig`.
    - `layout1`: the default layout
    - `layout2`: a layout specifically designed for tablets
    - `layout3`: the same as `layout1` but with the confirm button on the right

```swift
public enum ENSignatureBoxType {
    case layout1
    case layout2
    case layout3
    case graphologist
}
```

- `showInFullScreen` forces signatureBox's view to go in fullscreen, bypassing signatureField's ratio or other configs about SignatureView. It fills the entire screen.

- `minBioPackagesToAllowConfirmation` parameter disabled by default: allows to enable the confirm button after the specified number of collected biometric packages.

To present SignatureBox, call the function:

```swift
	public func present(inViewController viewController: UIViewController, pdfContainer: PDFContainer, fieldSize: CGSize, andSignerName signerName: String, debugMode: Bool = false, callback: ((ENResponse<ENBioResponse>) -> Void)?)
```

or

```swift
    public func present(inViewController viewController: UIViewController, debugMode: Bool = false, callback: ((ENResponse<ENBioResponse>) -> Void)?)
```

The response in the callback is an enum `ENBioResponse`, which returns this associated values with it:

```swift
public enum ENBioResponse {
    case encodedXml(value: String)
    case encodedXmlAndImage(xml: String, image: UIImage)
    case rawData(points: [ENSignaturePoint])
    case justPoint(point: ENSignaturePoint)
}
```

In common usage, it returns the encoded base64 xml and the generated image from SignatureView.
If you set `debugMode` flag to `true`, you receive back the raw list of generated points.

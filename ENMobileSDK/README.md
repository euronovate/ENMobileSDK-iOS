## ENMobileSDK (conventionally ENCore)
![](https://badgen.net/badge/stable/1.0.0/blue)

It's the core module. This module is included in every submodule, and keeps common functions to avoid circular dependencies between them. So it's not necessary to add to every module.

## COCOAPODS
Add `pod 'ENMobileSDK'` to your **PodFile**

## Basic usage

This SDK is builder-oriented, so every step is linked to previous and next, without possibility to shuffle them. You can find optional fields, but when something is required, is necessary to go on.

Below a basic setup (without any module). As you'll see, there's a function which requires an `ENAuthenticable` entity. These entities are the modules required in your application. Any of them has it's own builder with them configs and setups. Here you can see the `async/await` for the builder, but you can also call the *old one* with completion at the end.

```swift
Task {
    let mobileSDK = await ENMobileSDK
        .with(
            enAuthConfig: ENAuthConfig(
                baseUrl: baseUrl, 
                license: licenseKey, 
                username: username, 
                password: password
                ),
            enMobileSDKConfig: ENMobileSDKConfig(
                skipSSL: true, 
                oAuth2: nil, 
                enabledLanguages: [.en]))
		.with(enTheme: nil)
        .with(certificateOwnerInfo: ENCertificateOwnerInfo())
        .with(
            logLevel: .verbose, 
            logServerConfig: ENLogServerConfig(
                baseURL: "baseurl", 
                licenseCode: "licenseCode", 
                userID: "userID"), 
            saveLogsIniCloud: false)
        .with { initCallback in
            switch initCallback {
                case .error(let error):
                    ENMobileSDK.shared?.manageError(error, completion: {
                        ...
                    })
                default:
                    break
                }
			// here you can do whatever you need with errors or initCallback
		}
        .with(responseCallback: { responseCallback in
			// here you can do whatever you need with responseCallback
        })
        .with(authenticable: ...)
        .with(authenticableToEndBuilder: ...)
        .build()
}
```

### Logs
As you can see, there's a log section config, where you can set `logLevel`, `logServerConfig` (which sends most important logs to server setupped in baseURL), and a flag `saveLogsIniCloud`.
##### Logs accessibility
This last one, let's you save your logs directly on iCloud logs, so that you can easily check them and eventually send them to our team.
If you set it to `false`, they will be saved in `documents directory`.
- You set **true**:
	If you set true to this flag, to be able to see them in iCloud Drive directory, you have to:
		- Create an **iCloud Container** in Developer Apple Portal.
		- Add iCloud Capability in your app's Target, select iCloud Documents and select the container you've previously created.
		- Now if you build your app on a device with iCloud enabled, you should see a directory with your name's app in iCloud Drive.
- You set **false**:
	If you set false to this flag, logs are saved in `documents` folder, and if you add `Application supports iTunes file sharing` => `TRUE` to your plist file, you can access to your logs directly to Finder's device window if connected to your Mac. If your PC is Windows, you see them into iTunes App.
	
This builder returns an instance of `ENMobileSDK`, however you can also access to it's instance through `shared` instance.

### ENAuthenticables

```swift
public protocol ENAuthenticable {
 var productCode: String { get }
 var productSubcode: String { get }
 var isLicenseValid: Bool { get }
 static var name: ENMobileSDKModule { get }
 static var nameString: String { get }
}
```

It's a protocol which every module has to extend to be authenticated via [ENAuth](ENAuth/README).

Once authenticated, every module is accessible through an utility variable defined on `ENMobileSDK instance`. For example, module `ENViewer` has a variable defined on ENMobileSDK, so that it's instance is accessible with: `ENMobileSDK.shared?.viewer`.

You'll se 2 different builder declarations for Authenticable:

```swift
 func with(authenticable: ENAuthenticable) -> ENMobileSDKAuthenticableBuilder

 func with(authenticableToEndBuilder authenticable: ENAuthenticable) -> ENMobileSDKEndBuilder
```

The first one is used for the first authenticables you build, the last one is necessary for the last one, so that you can go on building your `ENMobileSDK`.
## Theme
To give an universal style to every module, we defined the `ENTheme` protocol. It contains variable which every module uses to define color, font or sizes for their graphic components.


If you want to create your own theme, just create a struct/class which extends this protocol:

```swift
public protocol ENTheme {
	var signatureBoxTheme: ENSignatureBoxTheme { get }
	var alertTheme: ENAlertTheme { get }
	var digitalSignageTheme: ENDigitalSignageTheme { get }
	var viewerTheme: ENViewerTheme { get }
}
```

Every variable is another protocol, which requires variables necessary to render our views from your theme.

#### SignatureBox theme 
```swift
public protocol ENSignatureBoxTheme {
	var signatureBox: BackgroundStyle { get }
	var userContainer: BackgroundStyle { get }
	var confirmIcon: BackgroundStyle { get }
	var cancelIcon: BackgroundStyle { get }
	var repeatIcon: BackgroundStyle { get }
	var buttonTextStyle: TextStyle { get }
	var userTextStyle: TextStyle { get }
	var timestampTextStyle: TextStyle { get }
	var topContainer: BackgroundStyle { get }
	var bottomContainer: BackgroundStyle { get }
	var cancelTint: TintStyle { get }
	var userTint: TintStyle { get }
	var confirmTint: TintStyle { get }
	var repeatTint: TintStyle { get }
	var font: ENFont { get }
}
```

#### AlertTheme theme 
```swift
public protocol ENAlertTheme {
	var confirmButton: LabelStyle { get }
	var cancelButton: LabelStyle { get }
	var normalButton: LabelStyle { get }
	var mainContainer: BackgroundStyle { get }
	var normalRightContainer: BackgroundStyle { get }
	var errorRightContainer: BackgroundStyle { get }
	var warningRightContainer: BackgroundStyle { get }


	var title: LabelStyle { get }
	var message: LabelStyle { get }
	var font: ENFont { get }
	var textField: BackgroundStyle { get }

	//MARK: - Progress style
	var progressTitle: LabelStyle { get }
	var progressSubtitle: LabelStyle { get }
	var progressContainer: BackgroundStyle { get }
	var progressBack: BackgroundStyle { get }
	var progress: BackgroundStyle { get }
}
```

#### DigitalSignage theme 

```swift
public protocol ENDigitalSignageTheme {
	var selectedLanguage: BackgroundStyle { get }
	var otherLanguages: BackgroundStyle { get }
	var showGuid: TextStyle { get }
	var tabletId: TextStyle { get }
	var tabletIdBackground: BackgroundStyle { get }
	var showGuidBackground: BackgroundStyle { get }
}
```

#### Viewer theme 

```swift
public protocol ENViewerTheme {
	var leftBar: ENBackgroundStyle { get }
	var rightBar: ENBackgroundStyle { get }
	var title: ENTextStyle { get }
	var subtitle: ENTextStyle { get }
	var enabledIcon: TintStyle { get }
	var disabledIcon: TintStyle { get }
	var confirm: ENBackgroundStyle { get }
	var abort: ENBackgroundStyle { get }
}
```


The whole theme system works by these structs:

##### BackgroundStyle
```swift      
public struct BackgroundStyle {
	var background: ENColor
	var cornerRadius: CGFloat
	var borderStyle: BorderStyle
}

```
##### TextStyle
```swift
public struct TextStyle {
	public enum FontWeight {
		case regular
		case light
		case medium
		case bold
	}

	var fontWeight: FontWeight
	var size: ENSize
	var text: ENColor
	var fontDefinition: ENFont
}
```
##### LabelStyle
```swift
public struct LabelStyle {
	var textStyle: TextStyle
	var backgroundStyle: BackgroundStyle
}
```
##### TintStyle
```swift      
public struct TintStyle {
	var tint: ENColor	
}
```
##### BorderStyle
```swift
public struct BorderStyle {
	var borderWidth: ENSize
	var border: ENColor
}
```

For convenience, I've defined `BasicColor`, `BasicSize` and `BasicFont` with their constructor necessary to extends `ENColor`, `ENSize` and `ENFont`. However you can create your own structs or just extend these protocols on your class to define your theme.

## Utilities
### Alerts

The main public function is 

```swift
@discardableResult 
public func showAlert(
	alertType: ENAlertViewController.AlertType, 
	title: String, 
	subtitle: String, 
	firstButton: AlertButton? = nil, 
	secondButton: AlertButton? = nil, 
	alertTextFieldAction: AlertTextField? = nil, 
	inViewController viewController: UIViewController? = nil)
```

To make its use much easier, you can find also some *packed* functions which returns a specific type of alert:

- Input alert:

```swift
 public func showInputAlert(
 	title: String, 
	subtitle: String, 
	alertTextFieldAction: AlertTextField, 
	inViewController viewController: UIViewController? = nil)
```

- Progress alert:

```swift
public func showProgress(
	withTitle title: String, 
	subtitle: String, 
	inViewController viewController: UIViewController? = nil)
```
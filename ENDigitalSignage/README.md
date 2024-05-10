## ENDigitalSignage

![](https://badgen.net/badge/stable/1.3.5/blue)

## COCOAPODS

Add `pod 'ENDigitalSignage', '1.3.5'` to your **PodFile**

It's a blackbox system to show a media slideshow based on a server-oriented media sync. When connected, it downloads every playlist offline.

The only one function you have to call is:

```swift
public func present(in viewController: UIViewController)
```

## ENDigitalSignageConfig

You can setup DigitalSignage with 2 different solutions.
As you can see in declarations below, both of them requires `ENCTAConfig` as a parameter.

This lets you customize the way to interact with digitalSignage, the way to show the alert for insert document GUID or choose from a list of local documents.

You can also choose if interact directly on images or on a button, which can be shown always, or appearing after a predefined number of taps.

```swift
public struct ENCTAConfig {
    var component: ENCTAUIComponent
    var presentationType: ENCTAType
}
```

```swift
public enum ENCTAType {
    case guid
    case documentList(documents: [ENDocum])
}
```

```swift
public enum ENCTAUIComponent {
    case hidden
    case directlyOnDS(event: ENCTAEventType)
    case button(presentationType: ENCTAPresentationType)
}
```

```swift
public enum ENCTAEventType {
    case easterEgg(numberOfTaps: Int)
    case tap
}
```

- #### Online mode

```swift
public init(baseURL: String, licenseCode: String, ctaConfig: ENCTAConfig)
```

- #### Offline mode

```swift
public init(mediaConfig: ENMediaConfig, ctaConfig: ENCTAConfig)
```

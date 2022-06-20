## ENPubSub

![](https://badgen.net/badge/stable/1.0.1/blue)

## COCOAPODS

Add `pod 'ENPubSub', '1.0.1'` to your **PodFile**

PubSub system communication to let sign or make other actions in realtime.

## Basic usage

The only one parameter extends the protocol _PubSubConfig_:

```swift
public protocol ENPubSubConfig: Settingable {
 var url: String { get set }
 var token: String { get set }
 var pubSubServiceType: ENPubSubServiceType { get set }
 func getTokenAndURL(completion: @escaping (String, String) -> Void) throws
 var messagePath: [String] { get set }
}
```

You can choose `DefaultPubSubConfig` for convention.

```swift


public struct DefaultPubSubConfig: ENPubSubConfig {
	 public var url: String
	 public var token: String
	 public var pubSubServiceType: ENPubSubServiceType
	 public var messagePath: [String]

	 public init(url: String, token: String, pubSubServiceType: ENPubSubServiceType, messagePath: [String]) {
		 self.url = url
		 self.token = token
		 self.pubSubServiceType = pubSubServiceType
		 self.messagePath = messagePath
	}
}
```

After setup, your `ViewController` or class should extend `ENPubSubDelegate` to listen for messages and pubSub connectionStatus.

```swift
public protocol ENPubSubDelegate: AnyObject {
 func startSignDocument(withGuid guid: String)
 func ping()
 func didConnected()
 func didDisconnected()
 func failedConnecting()
 func didReceive(message: [String: Any])
}
```

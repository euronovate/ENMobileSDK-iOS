## ENPubSub

![](https://badgen.net/badge/stable/1.3.9/blue)

## COCOAPODS

Add `pod 'ENPubSub', '1.3.9'` to your **PodFile**

PubSub system communication to let sign or make other actions in realtime.

## Basic usage

The only one parameter extends the protocol _PubSubConfig_:

```swift
public protocol ENPubSubConfig: Settingable {
	var url: String { get set }
	var token: String { get set }
	var pubSubServiceType: ENPubSubServiceType { get set }
	var pubSubReconnectionType: ENPubSubReconnectionType { get set }
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
	 public var pubSubReconnectionType: ENPubSubReconnectionType
	 public var messagePath: [String]

	public init(url: String, token: String, pubSubReconnectionType: ENPubSubReconnectionType = .defaultReconnectionType, pubSubServiceType: ENPubSubServiceType, messagePath: [String])
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

## Advanced config

`EnPubSubConfig` provides a new parameter, called `ENPubSubReconnectionType`, responsible to manage reconnection retries to socket server.

```swift
public enum ENPubSubReconnectionType {
    case enabled(connectionTimerInterval: Int, reconnectionTimerInterval: Int)
    case disabled

    public static var defaultReconnectionType: ENPubSubReconnectionType {
        .enabled(connectionTimerInterval: 60, reconnectionTimerInterval: 15)
    }
}
```

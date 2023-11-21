## ENAuth

![](https://badgen.net/badge/stable/1.3.4/blue)

`ENAuth` is a fundamental class used to activate and checking license of each submodules. You can configure ENAuth in two ways: ***with jwt*** for example to use in offline mode

```swift
.with(enAuthConfig: ENAuthConfig(baseUrl: "yourUrl", license: "yourLicenseKey", jwt: "yourJwt"),
```

or online mode with licenseKey and serverUrl:

```swift
.with(enAuthConfig: ENAuthConfig(baseUrl: "yourUrl", license: "yourLicenseKey"),
```

If you haven't serverUrl and licenseKey or Jwt you can contact [customer[dot]sales[at]euronovate[dot]com](mailto:customer.sales@euronovate.com) to request a trial. **Without their sdk won't initialized** so if you try to call an instance of a modules you will get a **crash**.

There is other parameter that you can pass via constructor of `ENAuthConfig`:

```swift
public struct ENAuthConfig {
    var baseUrl: String
    var license: String
    var username: String?
    var password: String?
    var jwt: String?
}
```

for example you can request an activation for onyl a specific product, or you can pass username e password.

### ENAuth Error

`ENAuthError` is returned for ENAuth Exceptions:

```swift
public enum ENAuthError: Error {
    case unknownError(message: String)
    case noToken
    case licenseVerificationWrongDeviceId
    case licenseApiGenericError(message: String)
    case licenseApiKeyOrAuthorizationNotValid
    case allProductsActivationFailed
    case licenseAPIJwtEmpty
    case errorServerWithoutBody(responseStatus: Int)
    case errorServerWithBody(responseStatus: Int, serverCode: String, serverMessage: String)
    case unableToParseJWTData
    case noProductToActivate
    case someProductsHaveProblems(expiring: [Product], expired: [Product], tokenExpired: [Product])
    case licenseNotValid
    case productNotExist
}
```

We have default exception in core, but there are other type specific to ENAuthException:

- **licenseVerificationWrongDeviceId** is returned when your jwt contains a wrong device uuid different of your current device.
- **someProductsHaveProblems** your jwt contains a different list of product(module) that you are trying to activate.
- **noProductToActivate** is returned when there isn't product(module) available to be activate.
- **licenseAPIJwtEmpty** your jwt is empty or not valid.

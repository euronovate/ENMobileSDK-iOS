# ENMobileSDK

![](https://badgen.net/badge/License/Apache%202.0/blue)

### THIS SOFTWARE REQUIRES A LICENSE TO WORK.

FOR ANY INFORMATION ABOUT, CONTACT US TO [customer[dot]sales[at]euronovate[dot]com](mailto:customer.sales@euronovate.com)

## OS support
- iOS minimum supported version: 14.0
- iOS maximum supported version: 16.0

## Installation

### Cocoapods

These modules are on a indipendent `.podspec`, located [here](https://github.com/euronovate/euronovate-pods).

So you need to add this line in your Podfile:

```ruby
source 'https://github.com/euronovate/euronovate-pods.git'
source 'https://cdn.cocoapods.org/'
```

At the end of your Podfile, you have to add also a post-install script:

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    end
  end
end
```

After that, you can import either module you need, just depending on what you need in your application.

**Note** that many of these modules (like **ENUtils**) are already imported by other modules. So it's not necessary to add them to your Podfile.

## Modules

- [ENMobileSDK (conventionally ENCore)](ENMobileSDK/README.md)
- [ENPDFMiddleware](ENPDFMiddleware/README.md)
- [ENSoftServer](ENSoftServer/README.md)
- [ENPDFProcessor](ENPDFProcessor/README.md)
- [ENViewer](ENViewer/README.md)
- [ENPresenter](ENPresenter/README.md)
- [ENBioLibrary](ENBioLibrary/README.md)
- [ENBioLibraryObjC](ENBioLibraryObjC/README.md)
- [ENDigitalSignage](ENDigitalSignage/README.md)
- [ENPubSub](ENPubSub/README.md)
- [ENSignatureBox](ENSignatureBox/README.md)

## CHANGELOGS

[View changelog](Changelogs/CHANGELOG.md)
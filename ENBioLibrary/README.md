## ENBioLibrary

![](https://badgen.net/badge/stable/1.0.3/blue)

## COCOAPODS

Add `pod 'ENBioLibrary', '1.0.3'` to your **PodFile**

It's the bridge between SignatureBox datas and XML biodata generator from ObjC ENBioLibrary.

## BASIC USAGE

The only one parameter requested in `ENBioLibrary` config is **publicKey**, necessary for xml encryption.

This library works under the hood with [ENSignatureBox](ENSignatureBox/README.md) module. This creates crypted bioData starting from user signature, and then gives them to let `ENPDFMiddleware` to save it into PDF with signature details.

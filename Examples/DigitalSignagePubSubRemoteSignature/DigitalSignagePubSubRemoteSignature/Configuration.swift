//
//  Configuration.swift
//  DigitalSignagePubSubRemoteSignature
//
//  Created by Giovanni Trezzi on 15/11/24.
//

import Foundation
import ENSoftServer
import ENPubSub

struct Configuration {

    static var pubSubConfig = DefaultPubSubConfig(url: "reaplce with url", token: "", pubSubServiceType: .signalR, messagePath: ["arguments", "notificationData"])

    static let digitalSignageUrl = "replace with digitalSignageUrl"
    static let digitalSignageLicenseCode = "replace with digitalSignageLicenseCode"

    static var softServerConfig = ENSoftServerConfig(baseURL: "replace with baseUrl",
                                                      licenseCode: "replace with licenseCode",
                                                      userID: "replace with userId")

    static let enauthUrl = "replace with enauthUrl"
    static let licenseKey = "replace with licenseKey"
    static let jwt = "replace with jwt"
}

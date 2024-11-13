//
//  Configuration.swift
//  DigitalSignage
//
//  Created by Giovanni Trezzi on 08/11/24.
//

import Foundation
import ENSoftServer

struct Configuration {

    static var softServerConfig = ENSoftServerConfig(baseURL: "replace with base url",
                                                              licenseCode: "replace with license code",
                                                              userID: "replace with user id")

    static let enauthUrl = "replace with enauth url"
    static let licenseKey = "replace with license key"
    static let jwt = "replace with jwt"

}

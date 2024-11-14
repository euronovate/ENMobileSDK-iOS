//
//  Configuration.swift
//  DigitalSignage
//
//  Created by Giovanni Trezzi on 13/11/24.
//

import Foundation
import ENSoftServer

struct Configuration {

    static var softServerConfig = ENSoftServerConfig(baseURL: "replace with baseURL",
                                                     licenseCode: "replace with license code",
                                                     userID: "replace with userID")

    static let enauthUrl = "replace with enauthUrl"
    static let licenseKey = "replace with licenseKey"
    static let jwt = "replace with jwt"

}

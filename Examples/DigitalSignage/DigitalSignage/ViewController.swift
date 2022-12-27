//
//  ViewController.swift
//  DigitalSignage
//
//  Created by Andrea Bellotto on 22/03/22.
//

import UIKit
import ENDigitalSignage
import ENMobileSDK

class ViewController: UIViewController {
    
    var isFirstLoad: Bool = true

    let baseUrl = ""
    
    let licenseKey = ""
    var username = ""
    var password = ""
    
    let logServerConfig = ENLogServerConfig(
        baseURL: "",
        licenseCode: "",
        userID: ""
    )
    
    let mobileSDKConfig = ENMobileSDKConfig(enabledLanguages: [.en, .gr], certificateSourceType: .generated, certificateOwnerInfo: .init(), networkConfig: ENNetworkConfig(
        skipSSL: true), keepScreenAlwaysOn: false, considerAllSignatureFieldCharacters: false
    )
    
    let digitalSignageConfig = ENDigitalSignageConfig(
        baseURL: "",
        licenseCode: "",
        ctaConfig: .init(component: .button(presentationType: .fade(event: .easterEgg(numberOfTaps: 5))), presentationType: .guid)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstLoad {
            isFirstLoad = false
            buildMobileSDK()
        }
        self.showLoader()
    }
    
    func buildMobileSDK() {
        SettingsManager.shared.resetSettingsManager()

        Task {
            let mobileSDK = await ENMobileSDK
                .with(
                    enAuthConfig: ENAuthConfig(baseUrl: baseUrl, license: licenseKey, username: username, password: password),
                    enMobileSDKConfig: mobileSDKConfig)
                .with(customTheme: nil)
                .with(certificateOwnerInfo: ENCertificateOwnerInfo(organization: "Walt Disney", countryCode: "Italia", localityName: "Samarate", commonName: "Pluto"))
                .with(logLevel: .verbose, logServerConfig: logServerConfig, saveLogsIniCloud: false)
                .with { initCallback in
                    switch initCallback {
                    case .error(let error):
                        DispatchQueue.main.async {
                            ENMobileSDK.shared?.manageError(error, completion: {
                                self.buildMobileSDK()
                            })
                        }
                    default:
                        break
                    }
                    print(initCallback)
                }
                .with(responseCallback: { responseCallback in
                    print(responseCallback)
                })
                .with(authenticableToEndBuilder:
                        ENDigitalSignage.with(digitalSignageConfig: digitalSignageConfig)
                        .build()
                )
                .build()
            self.hideLoader()
            mobileSDK.digitalSignage?.present(in: self)

        }
    }

}


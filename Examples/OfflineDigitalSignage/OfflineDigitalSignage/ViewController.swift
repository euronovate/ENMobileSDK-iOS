//
//  ViewController.swift
//  OfflineDigitalSignage
//
//  Created by Andrea Bellotto on 24/06/22.
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
                        ENDigitalSignage.with(digitalSignageConfig:
                            .init(mediaConfig: .init(landscapePlaceholder: nil, portraitPlaceholder: nil, dsImages: [
                                .init(mediaType: .image, fileName: "landscape-puzzle", fileExtension: "jpg", duration: 2),
                                .init(mediaType: .image, fileName: "landscape-river", fileExtension: "jpg", duration: 2),
                                .init(mediaType: .image, fileName: "landscape-house", fileExtension: "jpg", duration: 2),
                                .init(mediaType: .image, fileName: "landscape-frost", fileExtension: "jpg", duration: 2),
                                .init(mediaType: .image, fileName: "landscape-netherlands", fileExtension: "jpg", duration: 2),
                                .init(mediaType: .image, fileName: "landscape-planet", fileExtension: "jpg", duration: 2),
                                .init(mediaType: .image, fileName: "landscape-lake", fileExtension: "jpg", duration: 2),
                                .init(mediaType: .image, fileName: "portrait_road", fileExtension: "jpeg", duration: 2),
                                .init(mediaType: .image, fileName: "portrait-mountain", fileExtension: "jpg", duration: 2),
                                .init(mediaType: .image, fileName: "portrait_street", fileExtension: "jpg", duration: 2),
                                .init(mediaType: .image, fileName: "portrait_sunrise", fileExtension: "jpg", duration: 2),
                                .init(mediaType: .image, fileName: "portrait_nature", fileExtension: "jpg", duration: 2),
                                .init(mediaType: .image, fileName: "portrait_boscoverticale", fileExtension: "jpg", duration: 2),
                            ]), ctaConfig:
                                ENCTAConfig(component: .hidden, presentationType: .guid)))
                            .build()
                        
                )
                .build()
            self.hideLoader()
            mobileSDK.digitalSignage?.present(in: self)

        }
    }

}


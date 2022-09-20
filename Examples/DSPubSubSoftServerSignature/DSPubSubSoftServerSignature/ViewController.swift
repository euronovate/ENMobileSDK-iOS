//
//  ViewController.swift
//  DSPubSubSoftServerSignature
//
//  Created by Andrea Bellotto on 22/03/22.
//

import UIKit
import ENMobileSDK
import ENDigitalSignage
import ENSoftServer
import ENViewer
import ENPubSub
import ENSignatureBox
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

    let networkConfig = ENNetworkConfig(
        skipSSL: true
    )

    let digitalSignageConfig = ENDigitalSignageConfig(
        baseURL: "",
        licenseCode: "", ctaConfig: .init(component: .directlyOnDS(event: .tap), presentationType: .guid)
    )

    let softServerConfig = ENSoftServerConfig(baseURL: "", licenseCode: "", userID: "")

    let viewerConfig: ENViewerConfig = ENViewerConfig(signFieldPlaceholder: .signerName)
    
    let pubSubConfig = DefaultPubSubConfig(url: "", token: "", pubSubServiceType: .signalR, messagePath: ["", ""])

    let certificateOwnerInfo = ENCertificateOwnerInfo(organization: "", countryCode: "", localityName: "", commonName: "")

    let signatureBoxConfig = ENSignatureBoxConfig(signatureSourceType: .any, signatureImageConfig: .signatureAndTimestamp(watermarkReservedHeight: 0.4), useAlpha: true, signatureContentMode: .keepFieldRatio, enableSignatureOverwrite: true, updateDocumentStatusOnDismiss: false)

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
                enMobileSDKConfig: ENMobileSDKConfig(enabledLanguages: [.en, .gr], certificateSourceType: .generated, certificateOwnerInfo: .init(), networkConfig: networkConfig, keepScreenAlwaysOn: false, considerAllSignatureFieldCharacters: false))
                .with(customTheme: nil)
                .with(certificateOwnerInfo: certificateOwnerInfo)
                .with(logLevel: .verbose, logServerConfig: logServerConfig, saveLogsIniCloud: false)
                .with { initCallback in
                switch initCallback {
                case .error(let error):
                    ENMobileSDK.shared?.manageError(error, completion: {
                        self.buildMobileSDK()
                    })
                default:
                    break
                }
                print(initCallback)
            }
                .with(responseCallback: { responseCallback in
                print(responseCallback)
            })
                .with(authenticable: ENSoftServer.with(softServerConfig: softServerConfig).build())
                .with(authenticable: ENPubSub.with(pubsubConfig: pubSubConfig).build())
                .with(authenticable: ENViewer.with(config: viewerConfig).build())
                .with(authenticable: ENSignatureBox.with(signatureBoxConfig: signatureBoxConfig).build())
                .with(authenticableToEndBuilder:
                    ENDigitalSignage.with(digitalSignageConfig: digitalSignageConfig)
                    .build()
            )
                .build()
            self.hideLoader()
            mobileSDK.pubsub?.start()
            mobileSDK.digitalSignage?.present(in: self)

        }
    }

}


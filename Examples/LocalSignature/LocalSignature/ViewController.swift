//
//  ViewController.swift
//  LocalSignature
//
//  Created by Andrea Bellotto on 28/03/22.
//

import UIKit
import ENViewer
import ENSignatureBox
import ENPDFMiddleware
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
    
    let networkConfig = ENNetworkConfig(
        skipSSL: true
    )

    let certificateOwnerInfo = ENCertificateOwnerInfo(organization: "", countryCode: "", localityName: "", commonName: "")

    let signatureBoxConfig = ENSignatureBoxConfig(signatureSourceType: .any, signatureImageConfig: .signatureAndTimestamp, useAlpha: true, signatureContentMode: .keepFieldRatio, enableSignatureOverwrite: true)
    
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
                    enMobileSDKConfig:ENMobileSDKConfig(enabledLanguages: [.en, .gr], certificateSourceType: .generated, certificateOwnerInfo: .init(), networkConfig: networkConfig))
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
                .with(authenticable: ENViewer.build())
                .with(authenticableToEndBuilder: ENSignatureBox.with(signatureBoxConfig: signatureBoxConfig).build())
                .build()
            self.hideLoader()
            mobileSDK.pdfMiddleware?.openDocument(fromLocalSourceType: .unWritableUrl(url: Bundle.main.bundleURL), fileName: "Demo12_Verdi_PDFA1b", completion: { response in
                switch response {
                case .error(let error):
                    print(error)
                case .success(let structure):
                    DispatchQueue.main.async {
                        if let viewer = mobileSDK.viewer,
                           let json = structure.structureModel.json {
                            viewer.present(pdfContainer: structure, json: json, in: self)
                        }
                    }
                }
            })
        }
    }


}

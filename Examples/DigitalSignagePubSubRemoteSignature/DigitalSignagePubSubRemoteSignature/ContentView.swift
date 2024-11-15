//
//  ContentView.swift
//  DigitalSignagePubSubRemoteSignature
//
//  Created by Giovanni Trezzi on 15/11/24.
//

import SwiftUI
import ENMobileSDK
import ENPDFMiddleware
import ENViewer
import ENSoftServer
import ENSignatureBox
import ENBioLibrary
import ENPubSub
import ENDigitalSignage

struct ContentView: View {

    @State var isLoading: Bool = false

    @State var sdkInitialized: Bool = false
    @State var documentGUID: String = ""
    @State var showAlert:Bool = false
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""

    @State var selectedViewer = 0
    @State var selectedSignatureBox = 0
    @State var enMobileSDKCallback: ENMobileSDKCallback? = nil

    var body: some View {

        GeometryReader { screenProxy in
            ZStack {


                ZStack {}
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        Image(.sfondo)
                            .resizable()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .aspectRatio(contentMode: .fill)
                    )
                    .ignoresSafeArea()
                    .ignoresSafeArea(.keyboard, edges: .all)


                ScrollView {

                    VStack {

                        Spacer()
                            .frame(height: 70)

                        ButtonView(action: {

                            Task {
                                isLoading = true
                                await self.initENMobileSDK()
                                sdkInitialized = true
                                isLoading = false
                            }

                        }, label: "INITIALIZE SDK")
                        .frame(width: screenProxy.size.width * 0.65)
                        .opacity(sdkInitialized ? 0.6 : 1)
                        .disabled(sdkInitialized)

                        Spacer()
                            .frame(height: 40)

                        ButtonView(action: {

                            isLoading = true

                            if let currentViewController = ENMobileSDK.shared?.toppestViewController {
                                ENMobileSDK.shared?.pubsub?.start()
                                ENMobileSDK.shared?.digitalSignage?.present(in: currentViewController)
                            }

                            isLoading = false

                        }, label: "Start DS an PubSub")
                        .disabled(!sdkInitialized)
                        .opacity(!sdkInitialized ? 0.45 : 1)
                        .frame(width: screenProxy.size.width * 0.65)

                        Spacer()
                            .frame(height: 15)

                        Spacer()

                    }
                    .frame(maxWidth: .infinity)

                }

                if isLoading {
                    loadingView()
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    func loadingView() -> some View {
        return VStack {

            Spacer()
            if #available(iOS 15.0, *) {

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    .controlSize(.large)

            } else {

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))

            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.black.opacity(0.65)
        )
        .ignoresSafeArea()
    }

    func initENMobileSDK() async {

        if ENMobileSDK.shared != nil { return }

        guard let path = Bundle.main.path(forResource: "encert", ofType: "pem") else { fatalError("Resource not found: encert.pem") }
        guard let data = FileManager.default.contents(atPath: path) else { fatalError("Can not load file at: \(path)") }
        let publicKey = data.base64EncodedString()

        await ENMobileSDK
            .with(
                enAuthConfig: ENAuthConfig(baseUrl: Configuration.enauthUrl, license: Configuration.licenseKey, jwt: Configuration.jwt),
                enMobileSDKConfig: ENMobileSDKConfig(
                    enabledLanguages: [.en, .el, .it, .jor],
                    networkConfig: ENNetworkConfig(),
                    keepScreenAlwaysOn: false,
                    considerAllSignatureFieldCharacters: true,
                    appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-",
                    defaultSignatureMode: .graphometric
                )
            )
            .with(customTheme: DefaultTheme())
            .with(certificateOwnerInfo: ENCertificateOwnerInfo(organization: "Euronovate", countryCode: "IT", localityName: "Milan", commonName: "My Common Name")) // Il country code deve essere di 2 caratteri
            .with(logLevel: .debug, logServerSource: .none)
            .with { initCallback in
                print(initCallback)
            }
            .with(responseCallback: { responseCallback in
                print(responseCallback)
            })
            .with(authenticable: ENPDFMiddleware.with(config: ENPDFMiddlewareConfig(closeDocumentStatusOnConfirm: true,
                                                                                    abortDocumentStatusOnCancel: false,
                                                                                    disableBackButtonWhenSignaturesCompleted: false)).build())
            .with(authenticable: ENViewer.with(config: ENViewerConfig(signFieldPlaceholder: .defaultPlaceholder,
                                                                      idleTimeout: 0,
                                                                      viewDocumentAfterClose: false,
                                                                      viewerType: .layout1)).build())
            .with(authenticable: ENSignatureBox.with(signatureBoxConfig: ENSignatureBoxConfig(signatureSourceType: .any, signatureImageConfig: .signatureSignerNameAndTimestamp(watermarkReservedHeight: 0.3), useAlpha: false, signatureContentMode: .ignoreFieldRatio, enableSignatureOverwrite: true, layoutType: .layout1)).build())
            .with(authenticable: ENBioLibrary.with(bioLibraryConfig: ENBioLibraryConfig(publicKey: publicKey)).build())
            .with(authenticable:
                    ENDigitalSignage.with(digitalSignageConfig: ENDigitalSignageConfig(baseURL: Configuration.digitalSignageUrl, licenseCode: Configuration.digitalSignageLicenseCode, ctaConfig: .init(component: .button(presentationType: .always), presentationType: .guid))).build())
            .with(authenticable: ENPubSub.with(pubsubConfig: Configuration.pubSubConfig).build())
            .with(authenticableToEndBuilder: ENSoftServer.with(softServerConfig: Configuration.softServerConfig).build())
            .build()
    }
}

#Preview {
    ContentView()
}

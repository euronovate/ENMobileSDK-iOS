//
//  ContentView.swift
//  LocalAndRemoteSignature
//
//  Created by Giovanni Trezzi on 13/11/24.
//

import SwiftUI
import ENMobileSDK
import ENPDFMiddleware
import ENViewer
import ENSoftServer
import ENSignatureBox
import ENBioLibrary

struct ContentView: View {

    @State var isLoading: Bool = false

    @State var sdkInitialized: Bool = false
    @State var documentGUID: String = ""
    @State var showAlert:Bool = false
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""

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

                        HStack {

                            TextField("Remote document GUID", text: $documentGUID)
                                .foregroundColor(.black)
                                .overlay(
                                    Text("Remote document GUID")
                                        .padding(.leading, 5)
                                        .foregroundColor(documentGUID.isEmpty ? .gray : .clear)
                                        .allowsHitTesting(false),
                                    alignment: .leading
                                )
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.white)
                                )
                                .opacity(!sdkInitialized ? 0.85 : 1)
                                .disabled(!sdkInitialized)

                            ButtonView(action: {

                                
                                // Dismiss Keyboard (supporting from iOS14 onwards )
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

                                isLoading = true
                                ENMobileSDK.publish(model: documentGUID, toListenerToEvent: .signDocument(guid: documentGUID))
                                isLoading = false

//                                Task {
//
//                                    isLoading = true
//
//                                    do {
//
//
//                                        let container = try await ENMobileSDK.shared?.pdfMiddleware?.openDocumentAsync(fromGuid: documentGUID)
//
//                                        if let currentViewController = ENMobileSDK.shared?.toppestViewController,
//                                           let container = container,
//                                           let json = container.structureModel.json {
//
//                                            ENMobileSDK.shared?.viewer?.present(pdfContainer: container, json: json, in: currentViewController)
//                                        }
//
//                                    } catch {
//                                        alertTitle = "Error"
//                                        alertMessage = "\(error.localizedDescription)"
//                                        showAlert = true
//                                    }
//
//                                    isLoading = false
//                                }

                            }, label: "Open")
                            .frame(width: screenProxy.size.width * 0.15)
                            .opacity(!sdkInitialized ? 0.6 : 1)
                            .disabled(!sdkInitialized)

                        }
                        .padding(.trailing, 5)
                        .frame(width: screenProxy.size.width * 0.65)

                        Spacer()
                            .frame(height: 15)

                        VStack(alignment: .leading) {

                            HStack {

                                VStack(alignment: .leading) {
                                    Text("Local document")
                                        .font(.title3)
                                        .foregroundColor(.white)
                                }

                                Spacer()

                                ButtonView(action: {

                                    ENMobileSDK.shared?.showListAlert(AlertList(list: [ENDocum(name: "1-mandatory-1-optional-adobe", url: Bundle.main.url(forResource: "1-mandatory-1-optional-adobe", withExtension: "pdf")?.absoluteString ?? "")]) { document in

                                        isLoading = true

                                        ENMobileSDK.shared?.toppestViewController?.dismiss(animated: true) {

                                            ENMobileSDK.publish(model: document, toListenerToEvent: .signLocalDocument(document: document))

//                                            ENMobileSDK.shared?.pdfMiddleware?.openDocument(fromLocalSourceType: .unWritableUrl(url: Bundle.main.bundleURL), fileName: document.name) { response in
//
//
//
//                                                switch response {
//
//                                                    case .error(let error):
//
//                                                        alertTitle = "Error"
//                                                        alertMessage = "\(error.localizedDescription)"
//                                                        showAlert = true
//
//                                                    case .success(let tuple):
//
//                                                        let container = tuple.container
//
//                                                        if let currentViewController = ENMobileSDK.shared?.toppestViewController,
//                                                           let json = container.structureModel.json {
//
//                                                            ENMobileSDK.shared?.viewer?.present(pdfContainer: container, json: json, in: currentViewController, fileName: tuple.newName)
//                                                        }
//
//                                                    @unknown default:
//                                                        fatalError()
//                                                }
//
                                                isLoading = false
//                                            }
                                        }
                                    })

                                }, label: "Open")
                                .opacity(!sdkInitialized ? 0.45 : 1)
                                .disabled(!sdkInitialized)
                                .frame(width: screenProxy.size.width * 0.15)

                            }
                        }
                        .padding(.leading)
                        .padding(.trailing, 5)
                        .padding(.vertical, 5)
                        .frame(width: screenProxy.size.width * 0.65, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.gray.opacity(0.85))
                        )


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
                                                                                  viewDocumentAfterClose: false)).build())
            .with(authenticable: ENSignatureBox.with(signatureBoxConfig: ENSignatureBoxConfig(signatureSourceType: .any, signatureImageConfig: .signatureSignerNameAndTimestamp(watermarkReservedHeight: 0.3), useAlpha: false, signatureContentMode: .ignoreFieldRatio, enableSignatureOverwrite: true)).build())
            .with(authenticable: ENBioLibrary.with(bioLibraryConfig: ENBioLibraryConfig(publicKey: publicKey)).build())
            .with(authenticableToEndBuilder: ENSoftServer.with(softServerConfig: Configuration.softServerConfig).build())
            .build()

        self.enMobileSDKCallback = ENMobileSDK.subscribe(toSocketEvent: .closedDocument()) { event in

            Task {

                guard case .closedDocument(let guid) = event else {
                    return
                }

                try? await Task.sleep(nanoseconds: 1_000_000_000)

                if guid != nil {

                    self.documentGUID = ""

                    alertTitle = ""
                    alertMessage = "Document signed on SoftServer.\nTo review the document download it from SoftServer console"
                    showAlert = true

                } else {

                    alertTitle = ""
                    alertMessage = "Document signed."
                    showAlert = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

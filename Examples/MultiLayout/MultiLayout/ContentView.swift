//
//  ContentView.swift
//  MultiLayout
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


                        VStack {

                            Spacer()
                                .frame(height: 15)

                            HStack {

                                Text("Viewer Theme")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)

                                Spacer()

                                Picker(selection: $selectedViewer, label: Text("Choose an option")) {
                                    Text("Layout 1").tag(0)
                                    Text("Layout 2").tag(1)
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.enOrange.opacity(0.2))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                                .onAppear {
                                    UISegmentedControl.appearance().selectedSegmentTintColor = .enOrange
                                    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                                }
                                .frame(width: screenProxy.size.width * 0.30)
                                .onChange(of: selectedViewer) { _ in
                                    ENMobileSDK.shared?.viewer?.viewerConfig?.viewerType = selectedViewer == 0 ? .layout1 : .layout2
                                }

                            }
                            .padding(.vertical, 5)
                            .frame(width: screenProxy.size.width * 0.65, alignment: .leading)

                            Spacer()
                                .frame(height: 15)

                            HStack {

                                Text("Signature Box Theme")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)

                                Spacer()

                                Picker(selection: $selectedSignatureBox, label: Text("Choose an option")) {
                                    Text("Layout 1").tag(0)
                                    Text("Layout 2").tag(1)
                                    Text("Layout 3").tag(2)
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.enOrange.opacity(0.2))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                                .onAppear {
                                    UISegmentedControl.appearance().selectedSegmentTintColor = .enOrange
                                    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                                    //UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.enOrange)], for: .normal)
                                }
                                .frame(width: screenProxy.size.width * 0.30)
                                .onChange(of: selectedSignatureBox) { _ in
                                    ENMobileSDK.shared?.signatureBox?.signatureBoxConfig.layoutType = {

                                        switch selectedSignatureBox {
                                            case 0: return .layout1
                                            case 1: return .layout2
                                            default: return .layout3
                                        }

                                    }()
                                }

                            }
                            .padding(.vertical, 5)
                            .frame(width: screenProxy.size.width * 0.65, alignment: .leading)


                            Spacer()
                                .frame(height: 60)

                            ButtonView(action: {

                                isLoading = true
                                let document = ENDocum(name: "1-mandatory", url: Bundle.main.url(forResource: "1-mandatory", withExtension: "pdf")?.absoluteString ?? "")
                                ENMobileSDK.publish(model: document, toListenerToEvent: .signLocalDocument(document: document))
                                isLoading = false


                            }, label: "Open Document")
                            .frame(width: screenProxy.size.width * 0.35)

                            Spacer()
                                .frame(height: 15)

                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.gray.opacity(0.85))
                        )
                        .disabled(!sdkInitialized)
                        .opacity(!sdkInitialized ? 0.55 : 1)

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

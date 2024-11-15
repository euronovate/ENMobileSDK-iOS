//
//  ContentView.swift
//  DossierWithFesOtpSignature
//
//  Created by Giovanni Trezzi on 07/11/24.
//

import SwiftUI
import ENMobileSDK
import ENPDFMiddleware
import ENViewer
import ENSoftServer

struct ContentView: View {

    @State var isLoading: Bool = false

    @State var sdkInitialized: Bool = false
    @State var dossierGUID: String = ""
    @State var showAlert:Bool = false
    @State var errorMessage: String = ""

    @State var dossier: DossierInfo?
    @State var documents: [DossierDocumentInfo]?
    @State var closedDocumentsGUID:[String] = []
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

                            TextField("Dossier GUID", text: $dossierGUID)
                                .foregroundColor(.black)
                                .overlay(
                                    Text("Dossier GUID")
                                        .padding(.leading, 5)
                                        .foregroundColor(dossierGUID.isEmpty ? .gray : .clear)
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

                                Task {

                                    // Dismiss Keyboard (supporting from iOS14 onwards )
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

                                    isLoading = true

                                    do {

                                        documents = nil
                                        let retrievedDossier = try await ENMobileSDK.shared?.softServer?.findDossier(dossierGuid: dossierGUID)

                                        withAnimation {
                                            dossier = retrievedDossier
                                        }

                                    } catch {

                                        errorMessage = "\(error.localizedDescription)"
                                        showAlert = true
                                    }

                                    isLoading = false
                                }

                            }, label: "Find")
                            .frame(width: screenProxy.size.width * 0.15)
                            .opacity(!sdkInitialized ? 0.6 : 1)
                            .disabled(!sdkInitialized)

                        }
                        .frame(width: screenProxy.size.width * 0.65)


                        if let dossier = dossier {

                            dossierView(dossier, screenProxy: screenProxy)

                        }


                        if let documents = documents {

                            documentsView(documents, screenProxy: screenProxy)
                        }

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
                    title: Text("Error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onAppear {

                self.enMobileSDKCallback = ENMobileSDK.subscribe(toSocketEvent: .closedDocument()) { event in

                    Task {

                        guard case .closedDocument(let guid) = event else {
                            return
                        }

                        if let guid = guid {
                            closedDocumentsGUID.append(guid)
                        }
                    }
                }
            }
        }
    }

    func dossierView(_ dossier: DossierInfo, screenProxy: GeometryProxy) -> some View {
        return Group {

            Spacer()
                .frame(height: 40)

            VStack(alignment: .leading) {

                HStack {

                    VStack(alignment: .leading) {
                        Text("\(dossier.name ?? "")")
                            .font(.title3)
                            .foregroundColor(.black)

                        Text("\(dossier.guid ?? "")")
                            .font(.subheadline)
                            .foregroundColor(.white)

                        Text("\(dossier.description ?? "")")
                            .foregroundColor(.black)
                    }

                    Spacer()

                    ButtonView(action: {

                        Task {

                            isLoading = true

                            do {

                                let retrievedDocuments = try await ENMobileSDK.shared?.softServer?.findDocumentsInDossier(dossierGuid: dossier.guid ?? "")

                                withAnimation {
                                    documents = retrievedDocuments
                                }

                            } catch {

                                errorMessage = "\(error.localizedDescription)"
                                showAlert = true
                            }


                            isLoading = false
                        }

                    }, label: "Documents")
                    .frame(width: screenProxy.size.width * 0.15)



                }
            }
            .padding()
            .frame(width: screenProxy.size.width * 0.65, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.gray.opacity(0.85))
            )
        }
        .transition(.opacity)
    }

    func documentsView(_ documents: [DossierDocumentInfo], screenProxy: GeometryProxy) -> some View {
        return Group {

            Spacer()
                .frame(height: 40)

            VStack(alignment: .leading) {

                ForEach(documents, id: \.guid) { document in

                    HStack {

                        VStack(alignment: .leading) {
                            Text("\(document.name ?? "Document")")
                                .font(.title3)
                                .foregroundColor(.black)

                            Text("\(document.guid)")
                                .font(.subheadline)
                                .foregroundColor(.white)

                        }

                        Spacer()

                        ButtonView(action: {

                            Task {

                                isLoading = true
                                ENMobileSDK.publish(model: document.guid, toListenerToEvent: .signDocument(guid: document.guid, watermarkHeight: nil, watermarkOrderedValues: nil, forceSignatureType: .fes))
                                isLoading = false
                            }

                        }, label: "Firma OTP")
                        .disabled(closedDocumentsGUID.contains(document.guid))
                        .opacity(closedDocumentsGUID.contains(document.guid) ? 0.45 : 1)
                        .frame(width: screenProxy.size.width * 0.15)
                    }
                }
            }
            .padding()
            .frame(width: screenProxy.size.width * 0.65, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.gray.opacity(0.85))
            )
        }
        .transition(.opacity)
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

        await ENMobileSDK
            .with(
                enAuthConfig: ENAuthConfig(baseUrl: Configuration.enauthUrl, license: Configuration.licenseKey, jwt: Configuration.jwt),
                enMobileSDKConfig: ENMobileSDKConfig(
                    enabledLanguages: [.en, .el, .it, .jor],
                    networkConfig: ENNetworkConfig(),
                    keepScreenAlwaysOn: false,
                    considerAllSignatureFieldCharacters: true,
                    appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-",
                    defaultSignatureMode: .otpByDocumentGuid(numberOfDigits: 4, defaultHiddenDigits: true)
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
            .with(authenticableToEndBuilder: ENSoftServer.with(softServerConfig: Configuration.softServerConfig).build())
            .build()

    }
}

#Preview {
    ContentView()
}

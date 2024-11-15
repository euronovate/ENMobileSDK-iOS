//
//  ContentView.swift
//  DigitalSignage
//
//  Created by Giovanni Trezzi on 07/11/24.
//

import SwiftUI
import ENMobileSDK
import ENDigitalSignage
import ENPDFMiddleware
import ENViewer

struct ContentView: View {

    @State var isLoading: Bool = false

    @State var localReady: Bool = false
    @State var remoteReady: Bool = false

    var body: some View {

        GeometryReader { screenProxy in
            ZStack {


                Image(.sfondo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: screenProxy.size.width, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .clipped()
                    .zIndex(0)

                VStack {

                    Spacer()

                    ButtonView(action: {

                        Task {
                            isLoading = true
                            await self.initENMobileSDKForLocalDigitalSignage()
                            localReady = true
                            isLoading = false
                        }

                    }, label: "INITIALIZE SDK FOR LOCAL DIGITAL SIGNAGE")
                    .frame(width: screenProxy.size.width * 0.65)
                    .opacity(ENMobileSDK.shared != nil ? 0.6 : 1)
                    .disabled(ENMobileSDK.shared != nil)

                    ButtonView(action: {

                        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = scene.windows.first, let rootViewController = window.rootViewController {
                            ENMobileSDK.shared?.digitalSignage?.present(in: rootViewController)
                        }

                    }, label: "START LOCAL DIGITAL SIGNAGE")
                    .frame(width: screenProxy.size.width * 0.65)
                    .opacity(!localReady ? 0.6 : 1)
                    .disabled(!localReady)

                    Spacer()
                        .frame(height: 80)


                    ButtonView(action: {

                        Task {
                            isLoading = true
                            await self.initENMobileSDKForRemoteDigitalSignage()
                            remoteReady = true
                            isLoading = false
                        }

                    }, label: "INITIALIZE SDK FOR DIGITAL SIGNAGE")
                    .frame(width: screenProxy.size.width * 0.65)
                    .opacity(ENMobileSDK.shared != nil ? 0.6 : 1)
                    .disabled(ENMobileSDK.shared != nil)

                    ButtonView(action: {

                        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = scene.windows.first, let rootViewController = window.rootViewController {
                            ENMobileSDK.shared?.digitalSignage?.present(in: rootViewController)
                        }

                    }, label: "START DIGITAL SIGNAGE")
                    .frame(width: screenProxy.size.width * 0.65)
                    .opacity(!remoteReady ? 0.6 : 1)
                    .disabled(!remoteReady)

                    Spacer()
                }


                if isLoading {
                    VStack {

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
            }
            .ignoresSafeArea()
        }
    }

    func initENMobileSDKForLocalDigitalSignage() async {

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
            .with(authenticableToEndBuilder:
                    ENDigitalSignage.with(digitalSignageConfig:
                                            ENDigitalSignageConfig(mediaConfig:
                                                                    ENMediaConfig(landscapePlaceholder: nil,
                                                                                  portraitPlaceholder: nil,
                                                                                  dsImages: [
                                                                                    .init(mediaType: .image, fileName: "landscape-puzzle", fileExtension: "jpg", duration: 2),
                                                                                    .init(mediaType: .image, fileName: "landscape-river", fileExtension: "jpg", duration: 2),
                                                                                    .init(mediaType: .image, fileName: "landscape-house", fileExtension: "jpg", duration: 2),
                                                                                    .init(mediaType: .image, fileName: "landscape-frost", fileExtension: "jpg", duration: 2),
                                                                                    .init(mediaType: .image, fileName: "landscape-netherlands", fileExtension: "jpg", duration: 2),
                                                                                    .init(mediaType: .image, fileName: "landscape-planet", fileExtension: "jpg", duration: 2),
                                                                                    .init(mediaType: .video, fileName: "landscape-videoRoad", fileExtension: "mp4", duration: 43),
                                                                                    .init(mediaType: .video, fileName: "landscape-videoSeoul", fileExtension: "mp4", duration: 7),
                                                                                    .init(mediaType: .image, fileName: "landscape-lake", fileExtension: "jpg", duration: 2),
                                                                                    .init(mediaType: .image, fileName: "portrait_road", fileExtension: "jpeg", duration: 2),
                                                                                    .init(mediaType: .image, fileName: "portrait-mountain", fileExtension: "jpg", duration: 2),
                                                                                    .init(mediaType: .image, fileName: "portrait_street", fileExtension: "jpg", duration: 2),
                                                                                    .init(mediaType: .image, fileName: "portrait_sunrise", fileExtension: "jpg", duration: 2),
                                                                                    .init(mediaType: .image, fileName: "portrait_nature", fileExtension: "jpg", duration: 2),
                                                                                    .init(mediaType: .image, fileName: "portrait_boscoverticale", fileExtension: "jpg", duration: 2),
                                                                                  ]),
                                                                   ctaConfig:
                                                                    ENCTAConfig(component: .directlyOnDS(event: ENCTAEventType.easterEgg(numberOfTaps: 2)),
                                                                                presentationType: .documentList(documents: [
                                                                                    ("1 firma obbligatoria", "Documento monopagina e monofirma (bookmarks)", "1-mandatory-1-optional-adobe")
                                                                                ].map { ENDocum(name: $0.2, url: Bundle.main.bundleURL.absoluteString) },
                                                                                                                onSelection: { document in
                ENMobileSDK.publish(model: document.name, toListenerToEvent: .viewLocalDocument)
            }
                                                                                                               )
                                                                               )
                                            )
                    ).build()

            )
            .build()

    }


    func initENMobileSDKForRemoteDigitalSignage() async {

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
                                                                      idleTimeout: 4,
                                                                      viewDocumentAfterClose: false)).build())
            .with(authenticableToEndBuilder:
                    ENDigitalSignage.with(digitalSignageConfig:
                                            ENDigitalSignageConfig(baseURL: Configuration.digitalSignageUrl,
                                                                   licenseCode: Configuration.digitalSignageLicenseCode,
                                                                   ctaConfig: .init(component: .directlyOnDS(event: ENCTAEventType.easterEgg(numberOfTaps: 2)),
                                                                                    presentationType: .documentList(documents: [
                                                                                        ("1 firma obbligatoria", "Documento monopagina e monofirma (bookmarks)", "1-mandatory-1-optional-adobe")
                                                                                    ].map { ENDocum(name: $0.2, url: Bundle.main.bundleURL.absoluteString) },
                                                                                                                    onSelection: { document in
                ENMobileSDK.publish(model: document.name, toListenerToEvent: .viewLocalDocument)
            }
                                                                                                                   )
                                                                                   )
                                                                  )
                                         ).build()

            )
            .build()
    }
}

#Preview {
    ContentView()
}

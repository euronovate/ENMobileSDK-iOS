Pod::Spec.new do |s|
  s.name         = "ENPubSub"
  s.version      = "1.0.1"
  s.summary      = "PubSub system communication to let sign or make other actions in realtime."
  s.description  = <<-DESC
  PubSub system communication to let sign or make other actions in realtime.
  DESC
  s.homepage     = "https://www.euronovategroup.com"
  s.license = { :type => 'Copyright', :text => <<-LICENSE
                 Copyright 2022
                LICENSE
              }
  s.author             = { "$(git config user.name)" => "$(git config user.email)" }
  s.source = {
    :http => 'https://xcframeworks.s3.eu-south-1.amazonaws.com/ENPubSub/1.0.1/ENPubSub.xcframework.zip',
    :type => 'zip'
  }
  s.vendored_frameworks = "ENPubSub.xcframework"
  s.platform = :ios
  s.swift_version = "5.0"
  s.ios.deployment_target  = '14.0'
  s.dependency 'ENUtils', '1.0.1' 
  s.dependency 'ENMobileSDK', '1.0.1'
  s.dependency 'AnyCodable-FlightSchool', '~> 0.6.0'
  s.dependency 'SwiftSignalRClient'
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
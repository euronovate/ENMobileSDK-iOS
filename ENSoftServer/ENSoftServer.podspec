Pod::Spec.new do |s|
    s.name         = "ENSoftServer"
    s.version      = "1.0.0"
    s.summary      = "Communication between SDK and SoftServer webserver."
    s.description  = <<-DESC
    Communication between SDK and SoftServer webserver.
    DESC
    s.homepage     = "https://www.euronovategroup.com"
    s.license = { :type => 'Copyright', :text => <<-LICENSE
                   Copyright 2022
                  LICENSE
                }
    s.author             = { "$(git config user.name)" => "$(git config user.email)" }
    s.source = {
      :http => 'https://xcframeworks.s3.eu-south-1.amazonaws.com/ENSoftServer/1.0.0/ENSoftServer.xcframework.zip',
      :type => 'zip'
    }
    s.vendored_frameworks = "ENSoftServer.xcframework"
    s.platform = :ios
    s.swift_version = "5.0"
    s.ios.deployment_target  = '14.0'
    s.dependency 'ENUtils', '1.0.0' 
    s.dependency 'ENMobileSDK', '1.0.0'
    s.dependency 'AnyCodable-FlightSchool', '~> 0.6.0'
    s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  end
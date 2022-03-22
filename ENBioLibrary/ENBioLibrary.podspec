Pod::Spec.new do |s|
  s.name         = "ENBioLibrary"
  s.version      = "1.0.0"
  s.summary      = "It's the bridge between SignatureBox datas and XML biodata generator from ObjC ENBioLibrary."
  s.description  = <<-DESC
  It's the bridge between SignatureBox datas and XML biodata generator from ObjC ENBioLibrary.
  DESC
  s.homepage     = "https://www.euronovategroup.com"
  s.license = { :type => 'Copyright', :text => <<-LICENSE
                 Copyright 2022
                LICENSE
              }
  s.author             = { "$(git config user.name)" => "$(git config user.email)" }
  s.source = {
    :http => 'https://xcframeworks.s3.eu-south-1.amazonaws.com/ENBioLibrary/1.0.0/ENBioLibrary.xcframework.zip',
    :type => 'zip'
  }
  s.vendored_frameworks = "ENBioLibrary.xcframework"
  s.platform = :ios
  s.swift_version = "5.0"
  s.ios.deployment_target  = '14.0'
  s.dependency 'ENUtils', '1.0.0'
  s.dependency 'ENBioLibrary_ObjC', '1.0.0'
  s.dependency 'ENMobileSDK', '1.0.0'
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
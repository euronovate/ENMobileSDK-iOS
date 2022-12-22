Pod::Spec.new do |s|
  s.name         = "ENViewer"
  s.version      = "1.2.0"
  s.summary      = "Module which let you see a PDF from either local source or SoftServer."
  s.description  = <<-DESC
  Module which let you see a PDF from either local source or SoftServer..
  DESC
  s.homepage     = "https://www.euronovategroup.com"
  s.license = { :type => 'Copyright', :text => <<-LICENSE
                 Copyright 2022
                LICENSE
              }
  s.author             = { "$(git config user.name)" => "$(git config user.email)" }
  s.source = {
    :http => 'https://xcframeworks.s3.eu-south-1.amazonaws.com/ENViewer/1.2.0/ENViewer.xcframework.zip',
    :type => 'zip'
  }
  s.vendored_frameworks = "ENViewer.xcframework"
  s.platform = :ios
  s.swift_version = "5.0"
  s.ios.deployment_target  = '14.0'
  s.dependency 'ENPDFProcessor', '1.2.0' 
  s.dependency 'ENPresenter', '1.2.0' 
  s.dependency 'ENSignatureBox', '1.2.0'
  s.dependency 'ENPDFMiddleware', '1.2.0'
  s.dependency 'ENSoftServer', '1.2.0'
  s.dependency 'ENUtils', '1.2.0' 
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
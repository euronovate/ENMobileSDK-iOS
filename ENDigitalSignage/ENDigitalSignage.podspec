Pod::Spec.new do |s|
  s.name         = "ENDigitalSignage"
  s.version      = "1.1.0"
  s.summary      = "It's a blackbox system to show a media slideshow based on a server-oriented media sync."
  s.description  = <<-DESC
  It's a blackbox system to show a media slideshow based on a server-oriented media sync.
  DESC
  s.homepage     = "https://www.euronovategroup.com"
  s.license = { :type => 'Copyright', :text => <<-LICENSE
                 Copyright 2022
                LICENSE
              }
  s.author             = { "$(git config user.name)" => "$(git config user.email)" }
  s.source = {
    :http => 'https://xcframeworks.s3.eu-south-1.amazonaws.com/ENDigitalSignage/1.1.0/ENDigitalSignage.xcframework.zip',
    :type => 'zip'
  }  
  s.vendored_frameworks = "ENDigitalSignage.xcframework"
  s.platform = :ios
  s.swift_version = "5.0"
  s.ios.deployment_target  = '14.0'
  s.dependency 'ENMobileSDK', '1.1.0'
  s.dependency 'XMLCoder', '~> 0.13.1'
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
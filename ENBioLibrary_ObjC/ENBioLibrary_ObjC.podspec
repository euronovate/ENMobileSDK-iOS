Pod::Spec.new do |s|
    s.name         = "ENBioLibrary_ObjC"
    s.version      = "1.2.0"
    s.summary      = "Delegate module for xml bioData generation."
    s.description  = <<-DESC
    Delegate module for xml bioData generation.
    DESC
    s.homepage     = "https://www.euronovategroup.com"
    s.license = { :type => 'Copyright', :text => <<-LICENSE
                   Copyright 2022
                  LICENSE
                }
    s.author             = { "$(git config user.name)" => "$(git config user.email)" }
    s.source = {
      :http => 'https://xcframeworks.s3.eu-south-1.amazonaws.com/ENBioLibrary_ObjC/1.2.0/ENBioLibrary_ObjC.xcframework.zip',
      :type => 'zip'
    }  
    s.vendored_frameworks = "ENBioLibrary_ObjC.xcframework"
    s.platform = :ios
    s.ios.deployment_target  = '14.0'
    s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  end
Pod::Spec.new do |s|
  s.name             = 'flutter_pip'
  s.version          = '0.0.3'
  s.summary          = 'A Flutter plugin for Picture-in-Picture functionality'
  s.description      = <<-DESC
A Flutter plugin for Picture-in-Picture functionality on iOS and Android.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'
  s.framework = 'AVKit'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  
  # Add this line to include the bridging header
  s.private_header_files = 'Classes/flutter_pip-Bridging-Header.h'
end
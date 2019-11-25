#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_kbz_pay'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter Kbz Pay plugin.'
  s.description      = <<-DESC
A Flutter Kbz Pay plugin.
                       DESC
  s.homepage         = 'http://www.mmearn.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.ios.vendored_frameworks = 'Frameworks/KBZPayAPPPay.framework'
  s.vendored_frameworks = 'KBZPayAPPPay.framework'
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '8.0'
end


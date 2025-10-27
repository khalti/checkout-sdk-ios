#
# Be sure to run `pod lib lint KhaltiCheckout.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KhaltiCheckout'
  s.version          = '1.0.1'
  s.summary          = 'Khalti is the new generation Payment Gateway, Digital Wallet and API provider for various services.'
  s.description      = <<-DESC
  Khalti is the new generation Payment Gateway, Digital Wallet and API provider for various services. We provide you with true Payment Gateway, where you can accepts payments from: Khalti User, Net Banking customers of our partner banks (need not be Khalti user).
                        DESC
  s.homepage         = 'https://khalti.com/'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'khalti' => 'info@khalti.com' }
  s.source           = { :git => 'https://github.com/khalti/checkout-sdk-ios.git', :branch => 'master', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/KhaltiOfficial'
  s.ios.deployment_target = '12.0'
  s.source_files = 'KhaltiCheckout/Classes/**/*.{swift}'
  s.resource_bundles = {
      'KhaltiCheckout' => ['KhaltiCheckout/Assets/**/*.{png,storyboard,xib,xcassets}']
  }
  s.frameworks = 'UIKit'
  s.swift_versions = '4.0'
end

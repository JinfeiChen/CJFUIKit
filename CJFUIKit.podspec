#
# Be sure to run `pod lib lint CJFUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CJFUIKit'
  s.version          = '0.1.0'
  s.summary          = 'UI基类.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                        应用于iOS工程中，使用：eg. 创建UIView子类继承于CJFUIView
                       DESC

  s.homepage         = 'https://github.com/JinfeiChen/CJFUIKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jinfei_chen@icloud.com' => 'jinfei_chen@icloud.com' }
  s.source           = { :git => 'https://github.com/JinfeiChen/CJFUIKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'CJFUIKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CJFUIKit' => ['CJFUIKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

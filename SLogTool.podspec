#
# Be sure to run `pod lib lint SToolsLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SLogTool'
  s.version          = '0.0.5'
  s.summary          = 'log tool'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
log tool,include local cache
                       DESC

  s.homepage         = 'https://github.com/Ystarz/SLog.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sss' => 'sujianfu199@qq.com' }
  # s.source           = { :git => 'https://github.com/Ystarz/SDataTools.git', :tag => s.version.to_s }
  s.source           = { :git => 'https://github.com/Ystarz/SLog.git', :tag => s.version.to_s  }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.3'

  s.source_files = 'Classes/**/*.{h,m}'#'SToolsLib/Classes/**/*'
  s.dependency 'SDataToolsLib'
  
  # s.resource_bundles = {
  #   'SToolsLib' => ['SToolsLib/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
inhibit_all_warnings!

def commonPods #通用pods集
    # pod 'AFNetworking','~> 3.2.1'
    # pod 'Masonry'
    pod 'SDataTools'
    pod 'CocoaLumberjack'
end

def  appOnlyPods #app专用pods集
    pod 'MBProgressHUD'
end

def  extensionPods #扩展专用pods集
    pod 'GTSDKExtension'
end

commonPods

target 'SLog' do
  # Comment the next line if you don't want to use dynamic frameworks
  platform :ios, '9.3'
  use_frameworks!

  # Pods for SLog

  target 'SLogTests' do
    inherit! :search_paths
    # Pods for testing
  end

end


target "SLog_Mac" do
   platform :osx, '10.10'
  use_frameworks!
  # commonPods

   target 'SLog_MacTests' do
    inherit! :search_paths
    # Pods for testing
  end
end
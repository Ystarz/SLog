# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
inhibit_all_warnings!

def commonPods #通用pods集
    # pod 'AFNetworking','~> 3.2.1'
    # pod 'Masonry'
    pod 'SDataToolsLib'
end

def  appOnlyPods #app专用pods集
    pod 'MBProgressHUD'
end

def  extensionPods #扩展专用pods集
    pod 'GTSDKExtension'
end


target 'SLog' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  commonPods
  # Pods for SLog

  target 'SLogTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

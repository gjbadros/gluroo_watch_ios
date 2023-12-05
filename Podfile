# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

plugin 'cocoapods-patch'

target 'nightguard' do
  platform :ios, '12.4'

  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for nightguard
  pod 'Eureka'
  pod 'XLActionController'

  target 'nightguardTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'nightguardUITests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Eureka'
    pod 'XLActionController'
  end

end

target 'nightguard WatchKit App' do
  platform :watchos, '4.3'

  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for nightguard WatchKit App

end

# target 'nightguard Widget Extension' do
#   platform :watchos, '4.3'

#   # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
#   use_frameworks!

#   # Pods for nightguard WatchKit Extension

# end

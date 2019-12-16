# Uncomment the next line to define a global platform for your project
 platform :ios, '12.4'

target 'QRCodeReaderRx' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for QRCodeReaderRx
  pod 'SwiftLint'
  pod 'QRCodeReader.swift', '~> 10.1.0'
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'AVFoundationHelperRx', '~> 0.4'

  target 'QRCodeReaderRxTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Quick', '~> 2.1.0'
    pod 'Nimble', '~> 8'
    pod 'Cuckoo', '~> 1.0.6'
    pod 'RxBlocking', '~> 5.0'
    pod 'RxTest',     '~> 5.0'

  end
  
  target 'QRCodeReaderRxUITests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Nimble', '~> 8'
  end
  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # This works around a unit test issue introduced in Xcode 10.
      # We only apply it to the Debug configuration to avoid bloating the app size
      if config.name == "Debug" && defined?(target.product_type) && target.product_type == "com.apple.product-type.framework"
        config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = "YES"
      end
    end
  end
end

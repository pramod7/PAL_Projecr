# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'PAL' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PAL

 pod 'Firebase/Analytics'
 pod 'Firebase/Messaging'
 pod 'Firebase/Crashlytics'
 pod 'Alamofire', '~> 5.2.2'
 pod 'FSCalendar', '~> 2.8.1'
 pod 'ReachabilitySwift', '~> 3'
 pod 'SwiftyJSON', '~> 5.0.0'
 pod 'SVProgressHUD'
 pod 'GooglePlaces', '~> 4.1.0'
 pod 'ObjectMapper', '~> 3.5.3'
 pod 'IQKeyboardManagerSwift', '~> 6.5.6'
 pod 'KTCenterFlowLayout'
 pod 'SDWebImage', '~> 5.10.2'
 pod 'Firebase/MLVision'
 pod 'Firebase/MLVisionTextModel'


 post_install do |installer|
   installer.pods_project.build_configurations.each do |config|
     config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
   end
 end
end

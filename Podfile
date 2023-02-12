# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'PAL' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PAL

 pod 'Firebase/Analytics'
 pod 'Firebase/Messaging'
 pod 'Firebase/Crashlytics'
 pod 'Alamofire'
 pod 'FSCalendar'
 pod 'ReachabilitySwift', '~> 3'
 pod 'SwiftyJSON'
 pod 'SVProgressHUD'
 pod 'GooglePlaces'
 pod 'ObjectMapper', '~> 3.4'
 pod 'IQKeyboardManagerSwift'
 pod 'KTCenterFlowLayout'
 pod 'SDWebImage'
 pod 'Firebase/MLVision'
 pod 'Firebase/MLVisionTextModel'


 post_install do |installer|
   installer.pods_project.build_configurations.each do |config|
     config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
   end
 end
end

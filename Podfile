# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'
inhibit_all_warnings!

def common_pods
  
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    
    # Add the Accengage specs source
    source 'https://github.com/Accengage/CocoaPodsSpecs.git'
    
    # CocoaPods master specs
    source 'https://github.com/CocoaPods/Specs.git'
    
    # Tracking, Push Notif & Reports
    pod 'Accengage-iOS-SDK', '~>6.3.0'
    pod 'ATInternet-iOS-ObjC-SDK'
    pod 'AppDynamicsAgent'
    pod 'Adjust'
    pod 'Firebase/Core'
    pod 'Firebase/Database'
    pod 'iAdvize'
    pod 'R.swift', '~>4.0.0'
    pod 'Alamofire'
    pod 'AlamofireImage'
    pod 'MaterialComponents/TextFields', '~>56.0.0'
    pod 'KeychainSwift'
    pod 'SwiftyJSON'
    pod 'IQKeyboardManagerSwift'
    pod 'RealmSwift'
    pod 'PayPal-iOS-SDK'
    pod 'ActiveLabel'
    pod 'FSCalendar'
    pod 'SwiftyBeaver'
    pod 'LPColissimoUI', :git => 'https://build.bnum.laposte.fr/gitlab/app-mobile/commun/lib-ios/LPSharedColissimoUI.git', :branch => 'sprint/5'
    pod 'LPColissimo', :git => 'https://build.bnum.laposte.fr/gitlab/app-mobile/commun/lib-ios/LPSharedColissimoApiClient.git', :branch => 'us/2771'
#     pod 'Reveal-SDK'
#     Local Pods
    pod 'LPSharedMCM' , :git => 'https://build.bnum.laposte.fr/gitlab/app-mobile/commun/ios.git' , :branch => 'LPShared_APPPRO'
    #pod 'LPSharedMCM', :path => '../LPSharedMCMAppPro'
    #pod 'LPSharedMCM', path: '../../Pod/Common'
    
    pod 'LPSharedSUIVI', :git => 'http://build.bnum.laposte.fr/gitlab/app-mobile/commun/lib-ios/LPSharedSUIVI.git'
    pod 'LPSharedLOC' , :git => 'https://build.bnum.laposte.fr/gitlab/app-mobile/commun/ios.git' , :branch => 'LPSharedLOC_1.0'
    
#      pod 'LPSharedMCM' , :path => '../LPSharedMCM_PEMO'
#      pod 'LPColissimoUI' , :path => '../LPSharedColissimoUI'
#      pod 'LPColissimo' , :path => '../LPColissimoAPI'

    pod 'SwiftLint'

end

target 'LaPostePro' do
  common_pods
end

target 'LaPosteProTests' do
  
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  inherit! :complete
  pod 'Firebase'
  pod 'LPSharedMCM' , :git => 'https://build.bnum.laposte.fr/gitlab/app-mobile/commun/ios.git' , :branch => 'LPShared_APPPRO'
  pod 'R.swift', '~>4.0.0'
end


#target 'LaPosteProUITests' do
#  inherit! :complete
#end


#SWIFT_VERSION must be set to a supported value
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if target.name == 'IQKeyboardManagerSwift' || target.name == 'MessageKit' || target.name == 'SwiftGraylog' || target.name == 'MessageInputBar'
        config.build_settings['SWIFT_VERSION'] = '4.2'
        else
        config.build_settings['SWIFT_VERSION'] = '4.0'
      end
      if config.name == 'Debug'
        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'DEBUG=1']
        config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['$(inherited)','-DDEBUG']
        config.build_settings['GCC_OPTIMIZATION_LEVEL'] = '0'
      end
    end
  end
end

platform :ios, "5.0"

pod 'AFNetworking', '~> 1.0'
pod 'BlocksKit'
pod 'SVProgressHUD'
pod 'RHAddressBook', :head
pod 'EDQueue'
pod 'Inflections'
pod 'MBFaker'


post_install do |rep|
  rep.project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= []
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] -= ["RH_AB_INCLUDE_GEOCODING=0"]
      if target.name=="Pods-RHAddressBook"
        puts "Adding RH_AB_INCLUDE_GEOCODING=0 to GCC_PREPROCESSOR_DEFINITIONS for config #{config.name} for target #{target.name}"
        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] << "RH_AB_INCLUDE_GEOCODING=0"
      end
    end
  end
end


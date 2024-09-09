# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'Scrumdinger' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Scrumdinger
  pod 'ScrumdingerKMMLib', :path => '../../kmm/ScrumdingerKMMLib/shared/build/cocoapods/publish/release'

  target 'ScrumdingerTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ScrumdingerUITests' do
    # Pods for testing
  end
  
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == "ScrumdingerKMMLib"
            puts "Updating #{target.name} COCOAPODS_SKIP_KOTLIN_BUILD"
            target.build_configurations.each do |config|
                config.build_settings['COCOAPODS_SKIP_KOTLIN_BUILD'] = '$ENABLE_PREVIEWS'
            end
        end
    end
end

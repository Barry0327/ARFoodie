# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'
use_frameworks!
workspace 'ARFoodieApp'

project 'ARFoodieApp'
project 'ARFoodie/ARFoodie'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end

def ios_pods
  pod 'TransitionButton'
end

target 'ARFoodieiOS' do
  project 'ARFoodie/ARFoodie'
  ios_pods
end

target 'ARFoodieiOSTests' do
  project 'ARFoodie/ARFoodie'
  ios_pods
end 
# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'
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
  pod 'ChameleonFramework/Swift', :git => 'https://github.com/wowansm/Chameleon.git', :branch => 'swift5'
  pod 'ARCL'
  pod 'IHProgressHUD', :git => 'https://github.com/Swiftify-Corp/IHProgressHUD.git'
  pod 'StatusAlert'
  pod 'Cosmos', '~> 23.0.0'
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

target 'ARFoodieApp' do
  project 'ARFoodieApp'
  ios_pods
end

target 'ARFoodieAppTests' do
  project 'ARFoodieApp'
  ios_pods
end 
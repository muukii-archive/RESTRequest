#
# Be sure to run `pod lib lint RESTRequest.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "RESTRequest"
  s.version          = "0.3.1"
  s.summary          = "Reference implementation of BrickRequest for accessing REST APIs"
  s.description      = <<-DESC
                       Reference implementation of BrickRequest for accessing REST APIs
                     Powered by Alamofire
                       DESC

  s.homepage         = "https://github.com/muukii/RESTRequest"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "muukii" => "m@muukii.me" }
  s.source           = { :git => "https://github.com/muukii/RESTRequest.git", :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.requires_arc = true

  s.source_files = 'RESTRequest/*.swift'
  s.dependency 'BrickRequest', '~> 0.4.0'
  s.dependency 'SwiftyJSON', '~> 2.3.1'
  s.dependency 'RxSwift', '~> 2.3.1'
end

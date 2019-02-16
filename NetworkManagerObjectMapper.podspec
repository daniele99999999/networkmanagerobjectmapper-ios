Pod::Spec.new do |s|
  s.name             = "NetworkManagerObjectMapper"
  s.version          = "1.0.3"
  s.summary          = "NetworkManagerObjectMapper library DeeplyMadStudio"
  s.homepage         = "https://github.com/daniele99999999/networkmanagerobjectmapper-ios"
  s.license          = { :type => 'MIT' }
  s.author           = { "DeeplyMadStudio" => "deeplymadstudio@gmail.com" }
  s.source           = { :git => "https://github.com/daniele99999999/networkmanagerobjectmapper-ios", :tag => s.version }

  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.frameworks   = 'Foundation'

  s.dependency 'ObjectMapper', '3.3.0'
  s.dependency 'Alamofire', '4.5.1'
  s.dependency 'AlamofireObjectMapper', '5.0.0'
  s.dependency 'NetworkManager', '~> 1.0.0'
  s.dependency 'Utils', '~> 1.0.0'


  s.source_files = 'Classes/**/*'
end
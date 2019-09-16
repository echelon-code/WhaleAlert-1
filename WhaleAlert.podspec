#
# Be sure to run `pod lib lint WhaleAlert.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WhaleAlert'
  s.version          = '1.0.0'
  s.summary          = 'Swift implementation of the WhaleAlert API.'
  
  s.description      = <<-DESC
Whale Alert's API allows you to retrieve live and historical transaction data from major blockchains. Currently supported are Bitcoin, Ethereum, Ripple, NEO, EOS, Stellar and Tron. More blockchains will be added in the future. Please read our terms and conditions before using the API.
                       DESC

  s.homepage         = 'https://github.com/imryan/WhaleAlert'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ryan Cohen' => 'notryancohen@gmail.com' }
  s.source           = { :git => 'https://github.com/imryan/WhaleAlert.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/notryancohen'

  s.ios.deployment_target = '11.0'
  s.source_files = 'WhaleAlert/Classes/**/*'
end

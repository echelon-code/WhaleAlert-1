Pod::Spec.new do |s|
  s.name             = 'WhaleAlert'
  s.version          = '1.0.2'
  s.summary          = 'Swift implementation of the WhaleAlert API.'
  
  s.description      = <<-DESC
Whale Alert's API allows you to retrieve live and historical transaction data from major blockchains. Currently supported are Bitcoin, Ethereum, Ripple, NEO, EOS, Stellar and Tron. More blockchains will be added in the future. Please read our terms and conditions before using the API.
                       DESC

  s.homepage         = 'https://github.com/imryan/WhaleAlert'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ryan Cohen' => 'notryancohen@gmail.com' }
  s.source           = { :git => 'https://github.com/imryan/WhaleAlert.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/notryancohen'
  s.swift_versions = ['5.0']
  s.ios.deployment_target = '11.0'
  s.source_files = 'WhaleAlert/Classes/**/*'
end

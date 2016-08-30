
Pod::Spec.new do |s|
  s.name             = 'SwiftConnect'
  s.version          = '0.1.0'
  s.summary          = 'A pure value typed network http client.'

  s.description      = <<-DESC
SwiftConnect is a tiny framework to connect to Network easily
                       DESC

  s.homepage         = 'https://github.com/tuoitrevohoc/SwiftConnect'
  s.license          = { :type => 'WTFLICENSE', :file => 'LICENSE' }
  s.author           = { 'tuoitrevohoc' => 'tuoitrevohoc@me.com' }
  s.source           = { :git => 'https://github.com/tuoitrevohoc/SwiftState.git', :tag => s.version.to_s }

  s.social_media_url = 'https://twitter.com/tuoitrevohoc'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SwiftConnect/**/*'
end

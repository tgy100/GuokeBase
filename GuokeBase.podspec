Pod::Spec.new do |s|
  s.name         = 'GuokeBase'
  s.version      = '1.1.1'
  s.summary      = 'Objective C additions for humans. Write ObjC _like a boss_.'
  s.description  = '-map, -each, -select, unless(true){}, -includes, -upto, -downto, and many more!'
  s.homepage     = 'http://git.oschina.net/jarry622'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'guoke' => "lihuimin622@qq.com"}
  s.source       = { :git => 'https://git.oschina.net/jarry622/GuokeBase.git', :tag => s.version.to_s }
  s.social_media_url = "https://twitter.com/mneorr"

  s.ios.deployment_target = '4.0'
  s.osx.deployment_target = '10.6'

  s.requires_arc = false

  s.source_files = 'GkBase', 'GkBase/**/*.{h,m}'
end
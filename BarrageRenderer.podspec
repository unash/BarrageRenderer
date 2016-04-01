Pod::Spec.new do |s|
  s.name         = "BarrageRenderer"
  s.version      = "0.0.1"
  s.summary      = "With BarrageRenderer, you can easily create barrage or danmaku in your apps."
  s.homepage     = "https://github.com/unash/BarrageRenderer.git"
  s.license      = { :type => 'MIT License', :file => 'LICENSE' }
  s.author       = { "unash" => "unash@exbye.com" }
  s.platform     = :ios, '6.0'
  s.source       = { :git => "https://github.com/unash/BarrageRenderer.git", :branch => "master" }
  s.source_files  = "BarrageRenderer/*.{h,m}","BarrageRenderer/*/*.{h,m}"
end
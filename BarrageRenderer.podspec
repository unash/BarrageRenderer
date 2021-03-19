Pod::Spec.new do |s|
  s.name         = "BarrageRenderer"
  s.version      = "2.1.1"
  s.summary      = "With BarrageRenderer, you can easily create barrage or danmaku in your apps."
  s.homepage     = "https://github.com/unash/BarrageRenderer.git"
  s.license      = { :type => 'MIT License', :file => 'LICENSE' }
  s.author       = { "unash" => "unash@exbye.com" }
  
  s.ios.deployment_target = "6.0"
  s.tvos.deployment_target = "10.0"

  s.source       = { :git => "https://github.com/unash/BarrageRenderer.git", :tag => s.version }
  s.source_files = "BarrageRenderer/*.{h,m}","BarrageRenderer/*/*.{h,m}"
end

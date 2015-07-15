
Pod::Spec.new do |s|

  s.name         = "BarrageRenderer"
  s.version      = "1.0.0"
  s.summary      = "A short description of BarrageRenderer."

  s.description  = <<-DESC
                   A longer description of BarrageRenderer in Markdown format.
                   DESC

  s.homepage     = "https://github.com/unash/BarrageRenderer.git"

  s.author             = { "unash" => "unash@exbye.com" }
 
  s.source       = { :git => "https://github.com/unash/BarrageRenderer.git", :tag => "1.0" }

  s.source_files  = "BarrageRenderer/*.{h,m}","BarrageRenderer/*/*.{h,m}"
end

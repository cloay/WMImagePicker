Pod::Spec.new do |s|
  s.name         = "WMImagePicker"
  s.version      = "0.0.1"
  s.summary      = "WMImagePicker简单的图片i选择组件"
  s.description  = <<-DESC
简单的图片选择组件，使用方便
特点：
1、图片选择UI类似微信支持多图选择
2、支持缩略图、原图，原图使用lazy模式，使用时动态读取
3、支持图片库、照相机访问权限提示
                   DESC

  s.homepage     = "https://www.cloay.com"
  s.license      = "MIT"


  s.author             = { "shangweimin" => "shangrody@gmail.com" }
  s.platform     = :ios, "9.0"

  
  s.source       = { :git => "https://shangweimin@gitlab.tftiancai.com/shangweimin/TCBaseModule-iOS.git", :tag => s.version.to_s }
  s.source_files  = "Source/**/*.swift"
  # s.exclude_files = "README.md"

  # s.public_header_files = "Classes/**/*.h"


  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"



  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  #s.xcconfig = { "SWIFT_OBJC_BRIDGING_HEADER" => "$(SDKROOT)/usr/include/libxml2" }
end

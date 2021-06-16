#
#  Be sure to run `pod spec lint CMPhotoBrowser.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "CMPhotoBrowser"
  spec.version      = "0.0.1"
  spec.summary      = "图片浏览组件"

  spec.description  = "A short description of CMPhotoBrowser."
  spec.homepage     = "https://github.com/alenalen/CMPhotoBrowserDemo.git"
  spec.license      = "LICENSE"
  spec.author             = { "Allen" => "595004044@qq.com" }
  spec.source       = { :git => "", :tag => "0.0.1" }
  
  spec.swift_version = '4.0', '4.2', '5.0'
  spec.ios.deployment_target = '8.0'

  spec.source_files  = "Classes/**/*.{swift,xcdatamodeld}"

  spec.exclude_files = "Classes/Exclude"
  
  #解决target has transitive dependencies that include statically linked binaries
  spec.static_framework = true
  
  # spec.resource  = "icon.png"
  #spec.resources = "Images"
  spec.resource_bundles = {
#    'CMPhotoBrowser' => ['Classes/CMPhotoBrowserAssets.xcassets']
    'CMPhotoBrowser' => ['Classes/*.*']

  }
  #spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"

  spec.dependency 'ZFPlayer'
  spec.dependency 'ZFPlayer/ControlView'
  spec.dependency 'ZFPlayer/AVPlayer'
  spec.dependency 'SDWebImage'
  #spec.dependency 'SDWebImage/GIF'
  #spec.dependency 'FLAnimatedImage'
  spec.dependency 'SDWebImageFLPlugin'
end

#
#  Be sure to run `pod spec lint CMPhotoBrowser.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "CMPhotoBrowser"
  spec.version      = "0.0.1"
  spec.summary      = "图片浏览组件"

  spec.description  = "A short description of CMPhotoBrowser."
  spec.homepage     = "https://github.com/alenalen/"
  spec.license      = "LICENSE"
  spec.author             = { "allen" => "595004044@qq.com" }
  spec.source       = { :git => "https://github.com/alenalen/CMPhotoBrowserDemo.git", :tag => "0.0.1" }
  
  spec.swift_version = '4.0', '4.2', '5.0'
  spec.ios.deployment_target = '8.0'

  spec.source_files  = "Classes/**/*.{swift,xcdatamodeld}"
  spec.exclude_files = "Classes/Exclude"
  
  #解决target has transitive dependencies that include statically linked binaries
  spec.static_framework = true
  spec.requires_arc = true

  spec.resource_bundles = {
    'CMPhotoBrowser' => ['Classes/*.*']
  }

  spec.dependency 'ZFPlayer'
  spec.dependency 'ZFPlayer/ControlView'
  spec.dependency 'ZFPlayer/AVPlayer'
  spec.dependency 'SDWebImage'
  #spec.dependency 'SDWebImage/GIF'
  #spec.dependency 'FLAnimatedImage'
  spec.dependency 'SDWebImageFLPlugin'
end

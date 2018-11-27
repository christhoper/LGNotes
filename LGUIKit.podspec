#
#  Be sure to run `pod spec lint LGUIKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "LGUIKit"
  spec.version      = "0.0.1"
  spec.summary      = "平时开发所封住的一些UIKit"

  spec.homepage     = "https://github.com/christhoper/LGUIKit"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.license      = "MIT"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }



  spec.author             = { "hend" => "309875551@qq.com" }
  

  spec.platform     = :ios,"9.0"
  spec.ios.deployment_target = "9.0"



  spec.source       = { :git => "https://github.com/christhoper/LGUIKit.git", :tag => "0.0.1" }


  spec.source_files  = "LGUIKit", "LGUIKit/**/*.{h,m}"
  #spec.exclude_files = "Classes/Exclude"

  # spec.public_header_files = "Classes/**/*.h"

  spec.requires_arc = true


end


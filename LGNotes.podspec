

Pod::Spec.new do |spec|

  spec.name         = "LGNotes"
  spec.version      = "1.0.0"
  spec.summary      = "笔记"

  spec.homepage     = "https://github.com/christhoper/LGNotes"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.license      = "MIT"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }



  spec.author             = { "hend" => "309875551@qq.com" }
  

  spec.platform     = :ios,"9.0"
  spec.ios.deployment_target = "9.0"



  spec.source       = { :git => "https://github.com/christhoper/LGNotes.git", :tag => "{spec.version}" }


  spec.source_files  = "LGNotes", "LGNotes/**/*.{h,m}"
  #spec.exclude_files = "Classes/Exclude"

  # spec.public_header_files = "Classes/**/*.h"



  spec.requires_arc = true


end

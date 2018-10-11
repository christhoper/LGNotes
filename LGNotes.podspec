

Pod::Spec.new do |spec|

  spec.name         = "LGNotes"
  spec.version      = "1.0.1"
  spec.summary      = "笔记工具"

  spec.homepage     = "https://github.com/christhoper/LGNotes"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.license      = "MIT"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }



  spec.author             = { "hend" => "309875551@qq.com" }
  

  spec.platform     = :ios,"9.0"
  spec.ios.deployment_target = "9.0"



  spec.source       = { :git => "https://github.com/christhoper/LGNotes.git", :tag => "1.0.1" }


  spec.source_files  = "LGNotes", "LGNotes/**/*.{h,m}"
  #spec.exclude_files = "Classes/Exclude"

  # spec.public_header_files = "Classes/**/*.h"

  spec.resources = "LGNotes/Resource/LGNote.bundle"

  spec.requires_arc = true

  spec.dependency 'Masonry'
  spec.dependency 'MJExtension'
  spec.dependency 'MBProgressHUD'
  spec.dependency 'ReactiveObjC'
  spec.dependency 'AFNetworking'
  spec.dependency 'MJRefresh'

end
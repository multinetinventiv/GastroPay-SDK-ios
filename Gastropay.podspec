#
#  Be sure to run `pod spec lint Gastropay.podspec' to ensure this is a
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

  spec.name         = "Gastropay"
  spec.version      = "0.0.14"
  spec.summary      = "A framework of Gastropay."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  spec.description  = "The Gastropay framework is a tool to make payment using Gastropay in your app"

  spec.homepage     = "https://github.com/multinetinventiv/GastroPay-SDK-ios.git"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See https://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  spec.license = { :type => "MIT", :file => "LICENSE" }
  #spec.license      = "MIT (example)"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  spec.author             = { "inventiv" => "" }
  # Or just: spec.author    = "ilkersevim"
  # spec.authors            = { "ilkersevim" => "" }
  # spec.social_media_url   = "https://twitter.com/ilkersevim"
  spec.social_media_url   = "https://inventiv.com.tr"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # spec.platform     = :ios, "11.0"

  spec.ios.deployment_target = '12.0'

  # spec.platform     = :ios
  # spec.platform     = :ios, "5.0"

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  spec.source       = { :git => "https://github.com/multinetinventiv/GastroPay-SDK-ios.git", :tag => "#{spec.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  #spec.source_files  = "Classes", "Classes/**/*.{h,m}"

  spec.source_files = "Gastropay","Gastropay/*.{h,m,swift,strings}", "Gastropay/**/*.{h,m,swift,strings}"

  spec.exclude_files = "Gastropay/Exclude"

  # spec.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it workspec.

  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

  # spec.dependency 'Moya', '~> 13.0.1'

  spec.dependency 'Result', '~> 4.1'

  spec.dependency 'Then', '~> 2.6'

  spec.dependency 'YPNavigationBarTransition', '~> 2.0'

  spec.dependency 'MaterialComponents/TextFields'
  
  spec.dependency 'SDWebImage'
  
  spec.dependency 'SwiftMessages'

  spec.dependency 'AloeStackView'

  #spec.dependency 'ESTabBarController-swift'

  spec.dependency 'Swinject'

  spec.dependency 'AMXFontAutoScale'

  spec.dependency 'XCGLogger', '~> 7.0.1'

  spec.dependency 'Bartinter'

  spec.dependency 'AlignedCollectionViewFlowLayout'

  spec.dependency 'Lightbox'

  spec.dependency 'SnapKit'

  spec.dependency 'Codextended'
  
  spec.dependency 'SkeletonView'
  
  spec.dependency 'GoogleMaps'
  
  spec.dependency 'SwiftyMarkdown'

  spec.static_framework = true

  spec.xcconfig = { 'IPHONEOS_DEPLOYMENT_TARGET' => '12.0' }

  spec.xcconfig = { 'ENABLE_BITCODE' => 'NO' }

  spec.resource_bundle            = { "Gastropay" => 'Gastropay/Resources/**/*.{lproj,json,png,xcassets,storyboard,strings,xib,ttf,otf}' }

  spec.frameworks                     = 'Foundation', 'Security', 'UIKit'

  spec.swift_version = "5.0"

end

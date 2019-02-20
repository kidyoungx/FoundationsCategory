Pod::Spec.new do |spec|
  spec.name         = "FoundationsCategory"
  spec.version      = "1.0.1"
  spec.summary      = "NextStep Foundation Category macOS."

  spec.description  = <<-DESC
                        NextStep Foundation Category macOS. Such as NSImage.
                   DESC

  spec.homepage     = "https://github.com/kidyoungx/FoundationsCategory"

  spec.license      = "MPL-2.0"

  spec.author             = { "Kid Young" => "kidyoungx@gmail.com" }

  spec.platform     = :osx, "10.7"

  # spec.osx.deployment_target = "10.7"

  spec.source       = { :git => "https://github.com/kidyoungx/FoundationsCategory.git", :tag => "#{spec.version}" }

  spec.source_files  = "FoundationsCategory", "FoundationsCategory/**/*.{h,m}"
  spec.exclude_files = "SampleFoundationsCategory"

  spec.public_header_files = "FoundationsCategory/**/*.h"

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"

  spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end

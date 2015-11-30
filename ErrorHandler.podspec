Pod::Spec.new do |s|
  s.name             = "ErrorHandler"
  s.version          = "0.1.0"
  s.summary          = "A utility library for logging handled NSErrors and NSExceptions to a remote server."
  s.description      = "A utility library for logging handled NSErrors and NSExceptions to a remote server."
  s.homepage         = "https://github.com/johnjones4/ErrorHandler"
  s.license          = 'MIT'
  s.author           = { "John Jones" => "johnjones4@gmail.com" }
  s.source           = { :git => "https://github.com/johnjones4/ErrorHandler.git", :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*'
  s.public_header_files = 'Pod/Classes/**/*.h'
  s.dependency 'AFNetworking'
end

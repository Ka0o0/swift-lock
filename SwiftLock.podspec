Pod::Spec.new do |s|
  s.name             = 'SwiftLock'
  s.version          = '0.1.0'
  s.summary          = 'Add local authentication to your app with a breeze'
  s.description      = <<-DESC
    Add local authentication to your app with a breeze
                       DESC

  s.homepage         = 'https://github.com/Ka0o0/swift-lock'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kai Takac' => 'kai.takac@gmail.com' }
  s.source           = { :git => 'git@github.com:Ka0o0/swift-lock.git', :tag => s.version.to_s }

  s.requires_arc = true

  s.ios.deployment_target = '11.0'
  s.osx.deployment_target = '10.13.2'

  s.frameworks = 'Foundation', 'LocalAuthentication'
  s.dependency 'RxSwift', '~> 4.1'


  s.default_subspec = 'Domain','Platform'

  s.subspec 'Domain' do |ps|
    ps.source_files = 'SwiftLock/Domain/**/*.swift'
  end

  s.subspec 'Platform' do |ps|
    ps.source_files = 'SwiftLock/Platform/**/*.swift'
    ps.dependency 'IDZSwiftCommonCrypto', '~> 0.9'
    ps.dependency 'KeychainAccess', '~> 3.1'
  end
end

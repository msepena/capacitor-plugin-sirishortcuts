
  Pod::Spec.new do |s|
    s.name = 'MsepenaCapacitorPluginSirishortcuts'
    s.version = '0.0.1'
    s.summary = 'Capcacito siri shortcuts'
    s.license = 'MIT'
    s.homepage = 'https://'
    s.author = 'msepena'
    s.source = { :git => 'https://', :tag => s.version.to_s }
    s.source_files = 'ios/Plugin/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
    s.ios.deployment_target  = '11.0'
    s.dependency 'Capacitor'
  end
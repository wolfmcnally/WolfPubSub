Pod::Spec.new do |s|
    s.name             = 'WolfPubSub'
    s.version          = '1.0.1'
    s.summary          = 'A framework for intra-app communication via publishing and unpublishing notifications called Bulletins.'

    s.homepage         = 'https://github.com/wolfmcnally/WolfPubSub'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Wolf McNally' => 'wolf@wolfmcnally.com' }
    s.source           = { :git => 'https://github.com/wolfmcnally/WolfPubSub.git', :tag => s.version.to_s }

    s.swift_version = '4.2'

    s.source_files = 'WolfPubSub/Classes/**/*'

    s.ios.deployment_target = '9.3'
    s.macos.deployment_target = '10.13'
    s.tvos.deployment_target = '11.0'

    s.module_name = 'WolfPubSub'

    s.dependency 'WolfFoundation'
    s.dependency 'WolfConcurrency'
end

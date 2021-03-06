Pod::Spec.new do |spec|
    spec.name                  = "CHCSVParser"
    spec.version               = "2.1.1"
    spec.summary               = "A proper CSV parser for Objective-C"
    spec.description           = <<-DESC
                    	           A robust class for reading and writing delimited files in Cocoa.
	                             DESC
    spec.homepage              = "https://github.com/jnic/CHCSVParser"
    spec.license               = { :type => 'MIT', :file => 'LICENSE.txt' }
    spec.author                = "Dave DeLong"
    spec.social_media_url      = "http://twitter.com/davedelong"
    spec.ios.deployment_target = "6.0"
    spec.osx.deployment_target = "10.7"
    spec.watchos.deployment_target = "2.0"
    spec.source                = { :git => "https://github.com/jnic/CHCSVParser.git", :tag => "2.1.1" }
    spec.source_files          = "CHCSVParser/CHCSVParser/CHCSVParser.{h,m}"
    spec.requires_arc          = true
end

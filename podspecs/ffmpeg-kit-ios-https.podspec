Pod::Spec.new do |spec|
  spec.name = 'ffmpeg-kit-ios-https'
  spec.version = '6.0.1'
  spec.license = { :type => 'LGPL-3.0' }
  spec.homepage = 'https://github.com/hooper-ai/ffmpeg-kit-react-native'
  spec.summary = 'FFmpeg Kit iOS HTTPS Framework'
  spec.authors = 'Hooper AI'

  spec.source = {
    :http => 'https://github.com/hooper-ai/ffmpeg-kit-react-native/releases/download/v6.0.1/ffmpeg-kit-https-6.0.1-ios-xcframework.zip'
  }

  spec.platforms = { :ios => '12.1' }
  spec.requires_arc = false

  spec.vendored_frameworks = [
    'ffmpegkit.xcframework',
    'libavcodec.xcframework',
    'libavdevice.xcframework',
    'libavfilter.xcframework',
    'libavformat.xcframework',
    'libavutil.xcframework',
    'libswresample.xcframework',
    'libswscale.xcframework'
  ]

  spec.libraries = ['z', 'bz2', 'c++', 'iconv']
  spec.frameworks = ['AudioToolbox', 'AVFoundation', 'CoreMedia', 'VideoToolbox']
end

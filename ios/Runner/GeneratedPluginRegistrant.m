//
//  Generated file. Do not edit – overwritten by `flutter pub get`.
//
// clang-format off

#import "GeneratedPluginRegistrant.h"

// nfc_manager
#if __has_include(<nfc_manager/NfcManagerPlugin.h>)
#import <nfc_manager/NfcManagerPlugin.h>
#else
@import nfc_manager;
#endif

// image_picker_ios
#if __has_include(<image_picker_ios/FLTImagePickerPlugin.h>)
#import <image_picker_ios/FLTImagePickerPlugin.h>
#else
@import image_picker_ios;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [NfcManagerPlugin registerWithRegistrar:[registry registrarForPlugin:@"NfcManagerPlugin"]];
  [FLTImagePickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTImagePickerPlugin"]];
}

@end

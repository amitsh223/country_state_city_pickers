#import "CountryStateCityPickersPlugin.h"
#if __has_include(<country_state_city_pickers/country_state_city_pickers-Swift.h>)
#import <country_state_city_pickers/country_state_city_pickers-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "country_state_city_pickers-Swift.h"
#endif

@implementation CountryStateCityPickersPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCountryStateCityPickersPlugin registerWithRegistrar:registrar];
}
@end

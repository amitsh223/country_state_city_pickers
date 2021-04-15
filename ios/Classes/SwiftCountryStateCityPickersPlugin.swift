import Flutter
import UIKit

public class SwiftCountryStateCityPickersPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "country_state_city_pickers", binaryMessenger: registrar.messenger())
    let instance = SwiftCountryStateCityPickersPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}

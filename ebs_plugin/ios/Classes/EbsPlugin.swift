import Flutter
import UIKit

public class EbsPlugin: NSObject, FlutterPlugin, NativeHostApi {
  /*public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "ebs_plugin", binaryMessenger: registrar.messenger())
    let instance = EbsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }*/

  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger : FlutterBinaryMessenger = registrar.messenger()
    let api : NativeHostApi & NSObjectProtocol = Plugin.init()
    NativeHostApiSetup.setUp(binaryMessenger: messenger, api: api)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

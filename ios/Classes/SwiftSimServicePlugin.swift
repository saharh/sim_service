import Flutter
import UIKit
import CoreTelephony

public class SwiftSimServicePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "sim_service", binaryMessenger: registrar.messenger())
        let instance = SwiftSimServicePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getSimData":
            getSimData(call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func getSimData(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let telephony = CTTelephonyNetworkInfo.init()
        let carrier = telephony.subscriberCellularProvider
        let obj = [
            "carrierName" : carrier?.carrierName,
            "countryCode" : carrier?.isoCountryCode,
            "mcc" : carrier?.mobileCountryCode,
            "mnc" : carrier?.mobileNetworkCode
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: obj, options: JSONSerialization.WritingOptions.prettyPrinted)
            result(String.init(data: jsonData, encoding: String.Encoding.utf8))
        } catch {
            result(FlutterError(code: error.localizedDescription, message: nil, details: nil))
        }
    }
}

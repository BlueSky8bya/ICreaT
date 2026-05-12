import Foundation
import Flutter
import CoreBluetooth

class BluetoothChannel {
    private let METHOD_REQUEST_PERMISSION = "requestPermission"
    private let METHOD_GET_PERMISSION = "getPermission"
    private let METHOD_ALERT_POWER_ON = "alertPowerOn"
    
    let controller: FlutterViewController
    let channel: FlutterMethodChannel
    
    init(controller: FlutterViewController) {
        self.controller = controller
        channel = FlutterMethodChannel(name: "kr.caresquare.pbcr/bluetooth",
                                       binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
            switch(call.method){
            case self.METHOD_GET_PERMISSION:
                self.getPermission(result: result)
                break;
            case self.METHOD_ALERT_POWER_ON:
                self.alertPowerOn(result: result)
                break;
            case self.METHOD_REQUEST_PERMISSION:
                self.requestPermission(result: result)
                break;
            default:
                result(FlutterMethodNotImplemented)
            }
        })
    }
    
    private func getPermission(result: FlutterResult){
        var bleAuthCode: Int {
            var authCode = 3;
            
            if #available(iOS 13.1, *) {
                authCode = CBCentralManager.authorization.rawValue
            } else if #available(iOS 13.0, *) {
                authCode = CBCentralManager().authorization.rawValue
            }
            
            // Before iOS 13, Bluetooth permissions are not required
            NSLog("(flutter) yangbob CBCentralManager.authorization = %@", "ble auth code = \(getAuthString(rawValue: authCode))")
            return authCode
        }

        result(bleAuthCode)
    }
    
    private func getAuthString(rawValue: Int) -> String {
        switch(rawValue){
        case 0:
            return "Not Determinded"
        case 1:
            return "Restricted"
        case 2:
            return "Denied"
        case 3:
            return "Allowed Always"
        default:
            return "unknonw"
        }
    }
    
    private func alertPowerOn(result: FlutterResult){
        _ = CBCentralManager(delegate: nil, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey:true])
        result(nil)
    }

    private func requestPermission(result: FlutterResult){
        _ = CBCentralManager(delegate: nil, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey:true])
        result(nil)
    }
}

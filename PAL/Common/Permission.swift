//
//  AboutUsVC.swift
//  Operator-Log
//
//  Created by i-Phone7 on 08/11/20.
//

import Foundation
import CoreLocation
import AVFoundation
import UIKit
import CoreBluetooth
import Contacts

//MARK:- cameraPermission
func checkForCameraPermission(permissionGranted: @escaping (_ permission: Bool) -> Void) -> Void{
    if AVCaptureDevice.authorizationStatus(for: .video) == .authorized{
        permissionGranted(true)
    }
    else{
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
            permissionGranted(granted)
        })
    }
}

//MARK:- microphonePermission
func checkForMicrophonePermission(permissionGranted: @escaping (_ permission: Bool) -> Void) -> Void{
    if AVAudioSession.sharedInstance().recordPermission == .granted {
        permissionGranted(true)
    }
    else {
        AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
            permissionGranted(granted)
        })
    }
}

//MARK:- locationPermission
func checkForLocationPermission(permissionGranted: @escaping (_ permission: Bool) -> Void){
    if CLLocationManager.locationServicesEnabled(){
        switch CLLocationManager.authorizationStatus(){
        case .restricted, .denied:
            permissionGranted(false)
        case .authorizedAlways, .authorizedWhenInUse:
            permissionGranted(true)
        case .notDetermined:
            permissionGranted(false)
        default:
            break
        }
    }
    else{
        permissionGranted(false)
    }
}

//MARK:- alertMssg
func cameraPermissionAlert(from:UIViewController, showCancel: Bool) {
    let alert = UIAlertController(title: APP_NAME, message: "Please allow camera permission from Setting." , preferredStyle: .alert)
    alert.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
    alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (action) in
//        if let url = URL(string: UIApplication.openSettingsURLString) {
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            }
//        }
    }))
    if showCancel {
        alert.addAction(UIAlertAction(title: "Not Now", style: .default, handler: nil))
    }
    from.present(alert, animated: true, completion: nil)
}

//
//  Picker.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 25/02/2022.
//

import Foundation
import SwiftUI
import AVFoundation

enum Picker{
    enum Source{
        case library, camera
    }
    
    enum PickerError: Error, LocalizedError{
        case unAvailable
        case restricted
        case denied
        
        var errorDescription: String?{
            switch self{
            case .unAvailable:
                return NSLocalizedString("There is no camera in this device.",comment: "")
            case .restricted:
                return NSLocalizedString("You are not allowed to access media capture device.",comment: "")
            case .denied:
                return NSLocalizedString("You have explicitly denied permission for media capture, please open permission/Privacy/Camera and grant access for this application",comment: "")
            }
        }
    }
    
    static func checkPermissions() throws {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch authStatus{
            case .denied:
                PickerError.denied
            case .restricted:
                PickerError.restricted
            default:
                break
            }
        }else{
            throw PickerError.unAvailable
        }
  }
    
    struct CameraErrorType{
        let error: Picker.PickerError
        var message: String{
            error.localizedDescription
        }
        let button = Button("OK",role: .cancel){}
    }
    
}

//
//  AVFoundationHelperRx.swift
//  QRCodeReaderRx
//
//  Created by Nischal Hada on 7/28/19.
//  Copyright © 2019 NischalHada. All rights reserved.
//

import RxSwift
import AVFoundation

class AVFoundationHelperRx: AVFoundationHelperProtocolRx {
    
    // MARK: - Check and Respond to Camera Authorization Status
    
    var authorizationStatus: Single<CameraStatus> {
        return Single<CameraStatus>.create { single in
            let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
            switch cameraAuthorizationStatus {
            case .notDetermined:
                single(.success(CameraStatus.notDetermined))
            case .authorized:
                single(.success(CameraStatus.authorized))
            case .restricted:
                single(.success(CameraStatus.restricted))
            case .denied:
                single(.success(CameraStatus.denied))
            @unknown default:
                fatalError("AVCaptureDevice.authorizationStatus is not available on this version of OS.")
            }
            return Disposables.create()
        }
    }
    
    // MARK: - Request Camera Permission
    
    var requestAccess: Single<Bool> {
        return Single<Bool>.create { single in
            AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
                single(.success(accessGranted))
            })
            return Disposables.create()
        }
    }
}

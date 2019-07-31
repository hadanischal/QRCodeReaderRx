//
//  AVFoundationHelperProtocolRx.swift
//  QRCodeReaderRx
//
//  Created by Nischal Hada on 7/28/19.
//  Copyright © 2019 NischalHada. All rights reserved.
//

import RxSwift

protocol AVFoundationHelperProtocolRx {
    // MARK: - Check and Respond to Camera Authorization Status
    var authorizationStatus: Single<CameraStatus> { get }
    
    // MARK: - Request Camera Permission
    var requestAccess: Single<Bool> { get }
}

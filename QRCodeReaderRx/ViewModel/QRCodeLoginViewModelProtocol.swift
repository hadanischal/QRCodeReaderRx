//
//  QRCodeLoginViewModelProtocol.swift
//  QRCodeReaderRx
//
//  Created by Nischal Hada on 7/30/19.
//  Copyright © 2019 NischalHada. All rights reserved.
//

import RxSwift
import RxCocoa

enum QRCodeLoginRoute {
    case showQRCodeReader
    case alertCameraAccessNeeded
    case linkComplete
    case failedLinkedAlert // ceaseSpinner in failed
    case displaySpinner
}

protocol QRCodeLoginViewModelProtocol {
    func transformInput(linkButtonTaps taps: Observable<Void>, token: Observable<String>) -> Driver<QRCodeLoginRoute>
}

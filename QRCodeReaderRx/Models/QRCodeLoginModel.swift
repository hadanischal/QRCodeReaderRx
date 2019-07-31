//
//  QRCodeLoginModel.swift
//  QRCodeReaderRx
//
//  Created by Nischal Hada on 7/28/19.
//  Copyright © 2019 NischalHada. All rights reserved.
//

import Foundation
import RxSwift

class QRCodeLoginModel: QRCodeLoginModelProtocol {
    init() {
    }
    func login(withToken token: String) -> Completable {
        //TODO:- Mocking model for now
        return Completable.empty()
    }
}

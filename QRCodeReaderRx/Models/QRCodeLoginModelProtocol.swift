//
//  QRCodeLoginModelProtocol.swift
//  QRCodeReaderRx
//
//  Created by Nischal Hada on 7/30/19.
//  Copyright © 2019 NischalHada. All rights reserved.
//

import RxSwift

protocol QRCodeLoginModelProtocol {
    func login(withToken token: String) -> Completable
}

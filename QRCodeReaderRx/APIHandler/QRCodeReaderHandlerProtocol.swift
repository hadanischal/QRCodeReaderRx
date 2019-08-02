//
//  QRCodeReaderHandlerProtocol.swift
//  QRCodeReaderRx
//
//  Created by Nischal Hada on 7/28/19.
//  Copyright © 2019 NischalHada. All rights reserved.
//

import RxSwift

protocol QRCodeReaderHandlerProtocol {
    func upload(withToken token: String) -> Completable
}

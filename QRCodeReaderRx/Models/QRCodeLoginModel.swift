//
//  QRCodeLoginModel.swift
//  QRCodeReaderRx
//
//  Created by Nischal Hada on 7/28/19.
//  Copyright © 2019 NischalHada. All rights reserved.
//

import Foundation
import RxSwift

final class QRCodeLoginModel: QRCodeLoginModelProtocol {
    private let serverHandler: QRCodeReaderHandlerProtocol!

    init(withHandler serverHandler: QRCodeReaderHandlerProtocol = QRCodeReaderHandler()) {
        self.serverHandler = serverHandler
    }
    func login(withToken token: String) -> Completable {
        return serverHandler.upload(withToken: token)
    }
}

//
//  QRCodeLoginModel.swift
//  QRCodeReaderRx
//
//  Created by Nischal Hada on 7/28/19.
//  Copyright © 2019 NischalHada. All rights reserved.
//

import Foundation
import RxSwift

protocol QRCodeLoginModelProtocol {
    func login(withToken token: String) -> Observable<String>
}

final class QRCodeLoginModel: QRCodeLoginModelProtocol {
    private let serverHandler: QRCodeReaderHandlerProtocol!

    init(withHandler serverHandler: QRCodeReaderHandlerProtocol = QRCodeReaderHandler()) {
        self.serverHandler = serverHandler
    }
    func login(withToken token: String) -> Observable<String> {
        return serverHandler.upload(withToken: token)
            .andThen(Observable.just("Mock"))
    }
}

//
//  QRCodeReaderHandler.swift
//  QRCodeReaderRx
//
//  Created by Nischal Hada on 7/28/19.
//  Copyright © 2019 NischalHada. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class QRCodeReaderHandler: QRCodeReaderHandlerProtocol {

    private let webService: WebServiceProtocol!

    init(withWebservice webService: WebServiceProtocol = WebService()) {
        self.webService = webService
    }

    func upload(withToken token: String) -> Completable {
        ///TODO: api handell
        return Observable.just(())
            .delay(.seconds(5), scheduler: MainScheduler.instance)
            .ignoreElements()
    }

}

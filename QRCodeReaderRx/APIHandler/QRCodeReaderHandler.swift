//
//  QRCodeReaderHandler.swift
//  QRCodeReaderRx
//
//  Created by Nischal Hada on 7/28/19.
//  Copyright © 2019 NischalHada. All rights reserved.
//

import Foundation

class QRCodeReaderHandler: QRCodeReaderHandlerProtocol {

    private let webService: WebServiceProtocol!

    init(withWebservice webService: WebServiceProtocol = WebService()) {
        self.webService = webService
    }

}

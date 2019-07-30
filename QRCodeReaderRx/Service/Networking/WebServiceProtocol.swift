//
//  WebServiceProtocol.swift
//  QRCodeReaderRx
//
//  Created by Nischal Hada on 7/28/19.
//  Copyright © 2019 NischalHada. All rights reserved.
//

import Foundation

protocol WebServiceProtocol {
    func load<T>(resource: Resource<T>, completion: @escaping (T?) -> Void)
}

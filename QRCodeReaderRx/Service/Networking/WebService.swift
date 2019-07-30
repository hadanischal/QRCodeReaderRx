//
//  WebService.swift
//  QRCodeReaderRx
//
//  Created by Nischal Hada on 7/28/19.
//  Copyright © 2019 NischalHada. All rights reserved.
//

import Foundation

struct Resource<T> {
    let url: URL
    let parse: (Data) -> T?
}

class WebService: WebServiceProtocol {
    func load<T>(resource: Resource<T>, completion: @escaping (T?) -> Void) {
        print("url :", resource.url)
        URLSession.shared.dataTask(with: resource.url) { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    completion(resource.parse(data))
                }
            } else {
                completion(nil)
            }
            }.resume()
    }
}

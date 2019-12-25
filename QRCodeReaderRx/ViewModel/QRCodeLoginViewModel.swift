//
//  QRCodeLoginViewModel.swift
//  QRCodeReaderRx
//
//  Created by Nischal Hada on 7/28/19.
//  Copyright © 2019 NischalHada. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import AVFoundationHelperRx

final class QRCodeLoginViewModel: QRCodeLoginViewModelProtocol {

    //input
    private let model: QRCodeLoginModelProtocol!

    private let routeSubject = PublishSubject<QRCodeLoginRoute>()
    private let avFoundation: AVFoundationHelperProtocolRx
    private let disposeBag = DisposeBag()

    init(withModel model: QRCodeLoginModelProtocol = QRCodeLoginModel(),
         avFoundation: AVFoundationHelperProtocolRx = AVFoundationHelperRx()) {
        self.model = model
        self.avFoundation = avFoundation
    }

    func transformInput(linkButtonTaps taps: Observable<Void>, token: Observable<String>) -> Observable<QRCodeLoginRoute> {

        let linkButtonTaps =  taps.flatMap { [weak self] _ -> Observable<QRCodeLoginRoute> in
            return self?.handelLinkButtonTaps() ?? Observable.empty()
        }

        let token = token.flatMap({ [weak self] token -> Observable<QRCodeLoginRoute>  in
            guard let self = self else { return Observable.empty() }
            return Observable.concat(Observable.just(.displaySpinner),
                                     self.handelLinkToken(token))
        })

        return Observable.merge(linkButtonTaps, token)
    }

    private func handelLinkToken(_ token: String) -> Observable<QRCodeLoginRoute> {
        print("Received token VM\(token)")
        return model.login(withToken: token)
            .flatMap({ _ -> Observable<QRCodeLoginRoute> in
                return Observable.just(QRCodeLoginRoute.linkComplete)
            })
            .catchErrorJustReturn(.failedLinkedAlert)
    }

    private func handelLinkButtonTaps() -> Observable<QRCodeLoginRoute> {
        avFoundation.authorizationStatus
            .asObservable()
            .flatMap({ authorizationStatus -> Observable<QRCodeLoginRoute> in
                switch authorizationStatus {
                case .notDetermined:
                    return self.requestAccess()
                case .restricted, .denied:
                    return Observable.just(.alertCameraAccessNeeded)
                case .authorized:
                    return Observable.just(.showQRCodeReader)
                @unknown default:
                    assertionFailure("AVCaptureDevice.authorizationStatus is not available on this version of OS.")
                }
            })
    }

    private func requestAccess() -> Observable<QRCodeLoginRoute> {
        self.avFoundation.requestAccess
            .asObservable()
            .map { status -> QRCodeLoginRoute in
                if status {
                    return .showQRCodeReader
                } else {
                    return .alertCameraAccessNeeded
                }
        }
    }
}

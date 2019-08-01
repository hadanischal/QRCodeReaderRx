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

class QRCodeLoginViewModel: QRCodeLoginViewModelProtocol {

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

    func transformInput(linkButtonTaps taps: Observable<Void>, token: Observable<String>) -> Driver<QRCodeLoginRoute> {
        taps
            .subscribe(onNext: { [weak self] in
                self?.handelLinkButtonTaps()
            }).disposed(by: disposeBag)

        token
            .subscribe(onNext: { [weak self] token in
                self?.handelLinkToken(token)
            })
            .disposed(by: disposeBag)

        return routeSubject.asDriver(onErrorJustReturn: QRCodeLoginRoute.alertCameraAccessNeeded)
    }

    private func handelLinkToken(_ token: String) {
        print("Received token VM\(token)")
        //TODO: we will communicate with model for this part in next
        //TODO: Mocking for temporary purpose
        model.login(withToken: token).subscribe().disposed(by: disposeBag)
    }

    private func handelLinkButtonTaps() {
        avFoundation.authorizationStatus
            .subscribe(onSuccess: { [weak self] status in
                switch status {
                case .notDetermined:
                    self?.requestAccess()

                case .authorized:
                    self?.routeSubject.on(.next(QRCodeLoginRoute.showQRCodeReader))

                case .restricted, .denied:
                    self?.routeSubject.on(.next(QRCodeLoginRoute.alertCameraAccessNeeded))

                }
            })
            .disposed(by: disposeBag)
    }

    private func requestAccess() {
        self.avFoundation.requestAccess
            .subscribe(onSuccess: { [weak self] status in
                if status {
                    self?.routeSubject.on(.next(QRCodeLoginRoute.showQRCodeReader))
                } else {
                    self?.routeSubject.on(.next(QRCodeLoginRoute.alertCameraAccessNeeded))
                }
            })
            .disposed(by: self.disposeBag)
    }

}

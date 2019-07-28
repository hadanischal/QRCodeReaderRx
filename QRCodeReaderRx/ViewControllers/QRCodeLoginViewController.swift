//
//  QRCodeLoginViewController.swift
//  QRCodeReaderRx
//
//  Created by Nischal Hada on 7/28/19.
//  Copyright © 2019 NischalHada. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import QRCodeReader

class QRCodeLoginViewController: UIViewController, QRCodeReaderViewControllerDelegate {

    @IBOutlet weak var btnScan: UIButton!
    private let disposeBag = DisposeBag()

    // create the reader lazily to avoid cpu overload during the
    // initialization and each time we need to scan a QRCode
    
    lazy var reader: QRCodeReader = QRCodeReader()
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader                  = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton         = false
            $0.preferredStatusBarStyle = .lightContent
            $0.showOverlayView         = false
            $0.showSwitchCameraButton     = false
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnScan.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.showQRCodeReader()
        }).disposed(by: disposeBag)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - QRCodeReaderDelegate
    private func showQRCodeReader() {
        DispatchQueue.main.async {
            self.readerVC.modalPresentationStyle = .formSheet
            self.readerVC.delegate               = self
            self.present(self.readerVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - QRCodeReader Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        dismiss(animated: true) { [weak self] in
            print("Completion with result : \(result.value) of type \(result.metadataType)")
        }
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capture to: \(newCaptureDevice.device.localizedName)")
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }

}

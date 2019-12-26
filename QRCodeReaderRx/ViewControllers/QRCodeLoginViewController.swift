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
import WebKit
import PKHUD

class QRCodeLoginViewController: UIViewController, QRCodeReaderViewControllerDelegate {

    @IBOutlet weak var btnScan: UIButton!
    @IBOutlet weak var webView: WKWebView!

    var viewModel: QRCodeLoginViewModelProtocol = QRCodeLoginViewModel()
    private let tokenSubject = PublishSubject<String>()
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
        self.title = "Scan QRCode"
        self.setupViewModel()
        self.setupWebView()
        self.setAccessibilityIdentifier()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.displayWebView()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    func setupViewModel() {
        let taps = btnScan.rx.tap.asObservable()
        var token: Observable<String> {
            return tokenSubject.asObservable()
        }

        viewModel.transformInput(linkButtonTaps: taps, token: token)
            .asDriver(onErrorJustReturn: .failedLinkedAlert)
            .drive(onNext: { [weak self] result in
                self?.navigate(withRoute: result)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Navigation
    private func navigate(withRoute route: QRCodeLoginRoute) {
        switch route {
        case .showQRCodeReader:
            self.showQRCodeReader()
        case .alertCameraAccessNeeded:
            self.alertCameraAccessNeeded()
        case .linkComplete:
            self.linkingSucceed()
        case .failedLinkedAlert:
            self.linkingFailed()
        case .displaySpinner:
            self.displaySpinner()
        }
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
            self?.tokenSubject.on(.next(result.value))
        }
    }

    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capture to: \(newCaptureDevice.device.localizedName)")
    }

    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
        self.tokenSubject.onNext("Mock token")

    }

    // MARK: - Alert Camera Access Needed

    private func alertCameraAccessNeeded() {
        let appName = Bundle.main.displayName ?? "This app"

        let alert = UIAlertController(title: "This feature requires Camera Access",
                                      message: "In iPhone settings, tap \(appName) and turn on Camera access to scan QRCode",
            preferredStyle: UIAlertController.Style.alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { [weak self] (_: UIAlertAction) in
            self?.goToSettings()
        }

        alert.addAction(cancelAction)
        alert.addAction(settingsAction)
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Go To Device Settings
    private func goToSettings() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        UIApplication.shared.open(settingsAppURL)
    }

    // MARK: - Linking Failed
    private func linkingFailed() {
        HUD.hide()
        //self.ceaseSpinning
        self.showAlertView(withTitle: "Linking Failed", andMessage: "Completed with an error linking Failed")
    }

    // MARK: - Linking Succeed
    private func linkingSucceed() {
        HUD.hide()
        // TODO: ceaseSpinning
        // TODO: push to new view
    }

    // MARK: - Handling server interactions. Spinners and screen disablement
    private func displaySpinner() {
        // TODO: displaySpinner
        HUD.show(.progress)

    }

    private func setAccessibilityIdentifier() {
        navigationController?.navigationBar.accessibilityIdentifier = "QRCodeLoginViewController"
        btnScan.accessibilityIdentifier = "Scan"
        webView.accessibilityIdentifier = "webView"
    }

}

extension QRCodeLoginViewController: WKUIDelegate, WKNavigationDelegate {
    // MARK: - Navigation
    private func setupWebView() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }

    private func displayWebView() {
        if let url = Bundle.main.url(forResource: "instruction", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url)
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        switch navigationAction.navigationType {
        case .linkActivated:
            // Open links in Safari
            if let url = navigationAction.request.url,
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
            } else {
                //Open it locally
                decisionHandler(.allow)
            }
        default:
            //not a user click
            decisionHandler(.allow)
        }
    }
}

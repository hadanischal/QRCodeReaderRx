//
//  QRCodeLoginScreen.swift
//  QRCodeReaderRxUITests
//
//  Created by Nischal Hada on 11/8/19.
//  Copyright © 2019 NischalHada. All rights reserved.
//

import XCTest

class QRCodeLoginScreen: XCTest {

    let scanButton = XCUIApplication().buttons["Scan"]
    let cameraAccessAlert = XCUIApplication().alerts["Allow Camera Access"].buttons["OK"]

    let openSettingsButton = XCUIApplication().buttons["Open Settings"]
    let cancelButton = XCUIApplication().navigationBars["Settings"].buttons["Cancel"]

    let linkingFailedAlert = XCUIApplication().alerts["Linking Failed"].buttons["OK"]
    let okButton = XCUIApplication().buttons["Ok"]

    let displaySpinnerButton = XCUIApplication().buttons["displaySpinner"]
    let ceaseSpinningButton = XCUIApplication().buttons["ceaseSpinningButton"]

    // MARK: Settings Screen tap 

    func showQRCodeReader() {
        scanButton.tap()
        cameraAccessAlert.tap()
    }

    func alertCameraAccessNeeded() {
        scanButton.tap()
        cameraAccessAlert.tap()
    }

    func linkingSucceed() {
        scanButton.tap()
        ceaseSpinningButton.tap()
    }

    func linkingFailed() {
        scanButton.tap()
        linkingFailedAlert.tap()
    }

    func displaySpinner() {
        scanButton.tap()
        displaySpinnerButton.tap()
    }
}

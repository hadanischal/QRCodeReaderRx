//
//  QRCodeLoginViewControllerUITests.swift
//  QRCodeReaderRxUITests
//
//  Created by Nischal Hada on 11/8/19.
//  Copyright © 2019 NischalHada. All rights reserved.
//

import XCTest

class QRCodeLoginViewControllerUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
          continueAfterFailure = false
          XCUIApplication().launch()
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testScanButton() {
      //given
        let scanButton = app.segmentedControls.buttons["Scan"]
        let alert = app.alerts.tabs

    }

}

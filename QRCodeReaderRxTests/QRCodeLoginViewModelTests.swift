//
//  QRCodeLoginViewModelTests.swift
//  QRCodeReaderRxTests
//
//  Created by Nischal Hada on 8/1/19.
//  Copyright © 2019 NischalHada. All rights reserved.
//

import XCTest
import Quick
import Nimble
import Cuckoo
import RxCocoa
import RxTest
import RxBlocking
import RxSwift
import AVFoundationHelperRx
@testable import QRCodeReaderRx

class QRCodeLoginViewModelTests: QuickSpec {

    override func spec() {
        var testViewModel: QRCodeLoginViewModel!
        var mockModel: MockQRCodeLoginModelProtocol!
        var mockAVFoundation: MockAVFoundationHelperProtocolRx!
        var testScheduler: TestScheduler!

        describe("QRCodeLoginViewModel") {
            beforeEach {
                testScheduler = TestScheduler(initialClock: 0)

                mockModel =  MockQRCodeLoginModelProtocol()
                stub(mockModel, block: { (stub) in
                    when(stub.login(withToken: any())).thenReturn(Observable.empty())
                })

                mockAVFoundation = MockAVFoundationHelperProtocolRx()
                stub(mockAVFoundation, block: { (stub) in
                    when(stub.authorizationStatus).get.thenReturn(Single.just(AuthorizationStatus.authorized))
                    when(stub.requestAccess).get.thenReturn(Single.just(true))
                })

                testViewModel = QRCodeLoginViewModel(withModel: mockModel, avFoundation: mockAVFoundation)
            }

            afterEach {
                reset(mockModel)
                reset(mockAVFoundation)
            }

            context("when imageRequested i.e button is tapped", {
                var tapInput: Observable<Void>!
                var noTokenInput: Observable<String>!

                beforeEach {
                    tapInput = testScheduler.createColdObservable([Recorded.next(200, ())]).asObservable()
                    noTokenInput = testScheduler.createColdObservable([]).asObservable()
                }

                describe("when authorizationStatus is authorized ", {
                    beforeEach {
                        let status = testScheduler.createColdObservable([Recorded.next(10, AuthorizationStatus.authorized), Recorded.completed(20)]).asSingle()
                        stub(mockAVFoundation, block: { (stub) in
                            when(stub.authorizationStatus.get).thenReturn(status)
                        })
                    }
                    it("emits launchCamera", closure: {
                        let testObservable = testViewModel.transformInput(linkButtonTaps: tapInput, token: noTokenInput).asObservable()
                        let res = testScheduler.start { testObservable }
                        expect(res.events.count).to(equal(1))
                        let correctResult = [Recorded.next(420, QRCodeLoginRoute.showQRCodeReader)]
                        XCTAssertEqual(res.events, correctResult)
                    })
                })

                describe("when authorizationStatus is denied ", {

                    beforeEach {
                        let status = testScheduler.createColdObservable([Recorded.next(10, AuthorizationStatus.denied), .completed(20)]).asSingle()
                        stub(mockAVFoundation, block: { (stub) in
                            when(stub.authorizationStatus.get).thenReturn(status)
                        })
                    }
                    it("emits alertCameraAccessNeeded", closure: {
                        let testObservable = testViewModel.transformInput(linkButtonTaps: tapInput, token: noTokenInput).asObservable()
                        let res = testScheduler.start { testObservable }
                        expect(res.events.count).to(equal(1))
                        let correctResult = [Recorded.next(420, QRCodeLoginRoute.alertCameraAccessNeeded)]
                        XCTAssertEqual(res.events, correctResult)
                    })
                })

                describe("when authorizationStatus is restricted ", {
                    beforeEach {
                        let status = testScheduler.createColdObservable([Recorded.next(10, AuthorizationStatus.restricted), Recorded.completed(20)]).asSingle()
                        stub(mockAVFoundation, block: { (stub) in
                            when(stub.authorizationStatus.get).thenReturn(status)
                        })
                    }
                    it("emits alertCameraAccessNeeded", closure: {
                        let testObservable = testViewModel.transformInput(linkButtonTaps: tapInput, token: noTokenInput).asObservable()
                        let res = testScheduler.start { testObservable }
                        expect(res.events.count).to(equal(1))
                        let correctResult = [Recorded.next(420, QRCodeLoginRoute.alertCameraAccessNeeded)]
                        XCTAssertEqual(res.events, correctResult)
                    })
                })

                describe("when authorizationStatus is notDetermined ", {
                    context("when requestAccess is authorized ", {
                        beforeEach {

                            let status = testScheduler.createColdObservable([Recorded.next(10, AuthorizationStatus.notDetermined), Recorded.completed(20)]).asSingle()
                            let isAccess = testScheduler.createColdObservable([Recorded.next(10, true), Recorded.completed(20)]).asSingle()
                            stub(mockAVFoundation, block: { (stub) in
                                when(stub.authorizationStatus.get).thenReturn(status)
                                when(stub.requestAccess.get).thenReturn(isAccess)
                            })
                        }
                        it("emits showQRCodeReader", closure: {
                            let testObservable = testViewModel.transformInput(linkButtonTaps: tapInput, token: noTokenInput).asObservable()
                            let res = testScheduler.start { testObservable }
                            verify(mockAVFoundation).requestAccess.get()
                            expect(res.events.count).to(equal(1))
                            let correctResult = [Recorded.next(440, QRCodeLoginRoute.showQRCodeReader)]
                            XCTAssertEqual(res.events, correctResult)
                        })
                    })

                    context("when requestAccess is denied ", {
                        beforeEach {

                            let status = testScheduler.createColdObservable([Recorded.next(10, AuthorizationStatus.notDetermined), Recorded.completed(20)]).asSingle()
                            let isAccess = testScheduler.createColdObservable([Recorded.next(10, false), Recorded.completed(20)]).asSingle()
                            stub(mockAVFoundation, block: { (stub) in
                                when(stub.authorizationStatus.get).thenReturn(status)
                                when(stub.requestAccess.get).thenReturn(isAccess)
                            })
                        }
                        it("emits alertCameraAccessNeeded", closure: {
                            let testObservable = testViewModel.transformInput(linkButtonTaps: tapInput, token: noTokenInput).asObservable()
                            let res = testScheduler.start { testObservable }
                            verify(mockAVFoundation).requestAccess.get()
                            expect(res.events.count).to(equal(1))
                            let correctResult = [Recorded.next(440, QRCodeLoginRoute.alertCameraAccessNeeded)]
                            XCTAssertEqual(res.events, correctResult)
                        })
                    })

                })

            })

            context("Link request is made when QRCode is scanned successfully", {
                var notapInput: Observable<Void>!
                var tokenInput: Observable<String>!

                beforeEach {
                    notapInput = testScheduler.createColdObservable([]).asObservable()
                    tokenInput = testScheduler.createColdObservable([Recorded.next(200, "testToken")]).asObservable()
                }

                describe("when a link is successfuly requested", {
                    beforeEach {
                        stub(mockModel, block: { (stub) in
                            when(stub.login(withToken: any())).thenReturn(Observable.just("Mock Token"))
                        })
                    }

                    it("calls model with link token", closure: {
                        let testObservable = testViewModel.transformInput(linkButtonTaps: notapInput, token: tokenInput).asObservable()
                        let res = testScheduler.start { testObservable }
                        verify(mockModel).login(withToken: any())
                        expect(res.events.count).to(equal(2))
                        let correctResult = [Recorded.next(400, QRCodeLoginRoute.displaySpinner),
                                             Recorded.next(400, QRCodeLoginRoute.linkComplete)]
                        XCTAssertEqual(res.events, correctResult)
                    })

                    it("calls model with link token", closure: {
                        let testObservable = testViewModel.transformInput(linkButtonTaps: notapInput, token: tokenInput).asObservable()
                        _ = testScheduler.start { testObservable }
                        verify(mockModel).login(withToken: "testToken")
                    })

                 })

                describe("when a link request fails", {
                    beforeEach {
                        stub(mockModel, block: { (stub) in
                            when(stub.login(withToken: any())).thenReturn(Observable.error(RxError.unknown))
                        })
                    }

                    it("calls model with link token", closure: {
                        let testObservable = testViewModel.transformInput(linkButtonTaps: notapInput, token: tokenInput).asObservable()
                        let res = testScheduler.start { testObservable }
                        verify(mockModel).login(withToken: any())
                        expect(res.events.count).to(equal(2))
                        let correctResult = [Recorded.next(400, QRCodeLoginRoute.displaySpinner),
                                             Recorded.next(400, QRCodeLoginRoute.failedLinkedAlert)]
                        XCTAssertEqual(res.events, correctResult)
                    })

                 })
            })
        }
    }
}

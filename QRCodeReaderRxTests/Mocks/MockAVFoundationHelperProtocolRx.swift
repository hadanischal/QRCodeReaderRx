//
//  MockAVFoundationHelperProtocolRx.swift
//  QRCodeReaderRxTests
//
//  Created by Nischal Hada on 14/12/19.
//  Copyright © 2019 NischalHada. All rights reserved.
//
//swiftlint:disable all

import Cuckoo
import AVFoundationHelperRx
import RxSwift
@testable import QRCodeReaderRx

public class MockAVFoundationHelperProtocolRx: AVFoundationHelperProtocolRx, Cuckoo.ProtocolMock {
    
    public typealias MocksType = AVFoundationHelperProtocolRx
    
    public typealias Stubbing = __StubbingProxy_AVFoundationHelperProtocolRx
    public typealias Verification = __VerificationProxy_AVFoundationHelperProtocolRx

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: AVFoundationHelperProtocolRx?

    public func enableDefaultImplementation(_ stub: AVFoundationHelperProtocolRx) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public var authorizationStatus: Single<AuthorizationStatus> {
        get {
            return cuckoo_manager.getter("authorizationStatus",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(), defaultCall: __defaultImplStub!.authorizationStatus)
        }
        
    }

    public var requestAccess: Single<Bool> {
        get {
            return cuckoo_manager.getter("requestAccess",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(), defaultCall: __defaultImplStub!.requestAccess)
        }
        
    }
    
    public struct __StubbingProxy_AVFoundationHelperProtocolRx: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var authorizationStatus: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAVFoundationHelperProtocolRx, Single<AuthorizationStatus>> {
            return .init(manager: cuckoo_manager, name: "authorizationStatus")
        }
        
        var requestAccess: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAVFoundationHelperProtocolRx, Single<Bool>> {
            return .init(manager: cuckoo_manager, name: "requestAccess")
        }
    }

    public struct __VerificationProxy_AVFoundationHelperProtocolRx: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        var authorizationStatus: Cuckoo.VerifyReadOnlyProperty<Single<AuthorizationStatus>> {
            return .init(manager: cuckoo_manager, name: "authorizationStatus", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var requestAccess: Cuckoo.VerifyReadOnlyProperty<Single<Bool>> {
            return .init(manager: cuckoo_manager, name: "requestAccess", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    }
}

public class AVFoundationHelperProtocolRxStub: AVFoundationHelperProtocolRx {
    public var authorizationStatus: Single<AuthorizationStatus> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Single<AuthorizationStatus>).self)
        }
    }
    
    public var requestAccess: Single<Bool> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Single<Bool>).self)
        }
    }
}


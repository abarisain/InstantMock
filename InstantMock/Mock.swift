//
//  Mock.swift
//  InstantMock
//
//  Created by Patrick on 06/05/2017.
//  Copyright © 2017 pirishd. All rights reserved.
//


/** Main protocol for adding mocking capabilities to any object, using delegation */
public protocol MockDelegate {

    /// Provide mock instance
    var it: Mock { get }
}


/** Protocol for mock expectations */
public protocol MockExpectation {

    /// Create new expectation for current instance
    func expect() -> Expectation

    /// Verify all expections on the current instance
    func verify()
}


/** Protocol for stubs */
public protocol MockStub {

    /// Create new stub for current instance
    func stub() -> Stub
}



/**
    A `Mock` instance is dedicated to being used in unit tests, in order to mock some specific behaviors.
    It can be used in two particular cases:
    - **verify** some behaviors with **expectations** (represented by the `Expectation` class)
    - **stub** behaviors, to return or perform some actions under certain conditions (stubs are represented by the
    `Stub` class)

    Example of an expectation being verified:

        let mock: Mock
        mock.expect().call(mock.someMethod())
        mock.verify()

    Example of a stub:

        let mock: Mock
        mock.stub().call(mock.someMethod()).andReturn(someValue)

 */
public class Mock {

    fileprivate var expectationBeingRegistered: Expectation?
    fileprivate var stubBeingRegistered: Stub?

    fileprivate let expectationStorage = CallInterceptorStorage<Expectation>()
    fileprivate let stubStorage = CallInterceptorStorage<Stub>()

}


/* Extension for handling mock expectations */
extension Mock: MockExpectation {

    @discardableResult
    public func expect() -> Expectation {
        let stub = Stub()
        let expectation = Expectation(withStub: stub)

        // mark instances as being ready for registration
        self.expectationBeingRegistered = expectation
        self.stubBeingRegistered = stub

        return expectation
    }


    public func verify() {
        // FIXME: nothing for now
    }


    /** Handle expectations */
    fileprivate func handleExpectations(_ args: [Any?], function: String) {
        // FIXME: to do
    }


}


/* Extension for handling stubs */
extension Mock: MockStub {

    @discardableResult
    public func stub() -> Stub {
        let stub = Stub()

        // mark instance as being ready for registration
        self.stubBeingRegistered = stub

        return stub
    }


    /** handle stubs */
    fileprivate func handleStubs<T>(_ args: [Any?], function: String) -> T? {
        var ret: T?

        // default value
        if let mockUsableType = T.self as? MockUsable.Type {
            if let value = mockUsableType.anyValue as? T {
                ret = value
            }
        }

        return ret
    }

}


// MARK: Call
extension Mock {


    /** Call with no return value */
    public func call(_ args: Any?..., function: String = #function) -> Void {
        let ret: Void? = self.handleCall(args, function: function)
        return ret ?? Void()
    }


    /** Call with return type object */
    public func call<T>(_ args: Any?..., function: String = #function) -> T? {
        return self.handleCall(args, function: function) as T?
    }


    /** Handle a call */
    @discardableResult
    private func handleCall<T>(_ args: [Any?], function: String) -> T? {
        self.handleExpectations(args, function: function)
        return self.handleStubs(args, function: function)
    }

}

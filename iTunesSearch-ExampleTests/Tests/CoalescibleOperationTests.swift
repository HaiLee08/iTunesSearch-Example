//
//  CoalescibleOperationTests.swift
//  iTunesSearch-Example
//
//  Created by William Boles on 12/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import XCTest

@testable import iTunesSearch_Example

class CoalescibleOperationTests: XCTestCase {
    
    class TestCoalescingOperation<T>: CoalescibleOperation<T> {
        
        // MARK: - Init
        
        override init(identifier: String = "testCoalescingOperationExampleIdentifier") {
            super.init(identifier: identifier)
        }
        
        // MARK: - Lifecycle
        
        override func start() {
            super.start()
            
            sleep(1)
            
            complete(result: DataRequestResult.failure)
        }
    }
    
    // MARK: - Tests
    
    // MARK: DidComplete
    
    func test_didComplete_closuresCalled() {
        var operationCalledBack = false
        let expectation = self.expectation(description: "Closure called")
        let operation = CoalescibleOperation<Any>(identifier: "test")
        operation.completion = {(successful) in
            operationCalledBack = true
            expectation.fulfill()
        }
        
        operation.complete(result: DataRequestResult.failure)
        
        waitForExpectations(timeout: 2) { (error) in
            XCTAssertTrue(operationCalledBack)
        }
    }
    
    func test_didComplete_callBackOnThreadItWasQueuedOn() {
        var callBackOnThreadA: OperationQueue!
        let expectationA = expectation(description: "Closure called")
        
        let queue = OperationQueue()
        queue.addOperation {
            let operationA = CoalescibleOperation<Any>(identifier: "test")
            operationA.completion = {(successful) in
                callBackOnThreadA = OperationQueue.current!
                expectationA.fulfill()
            }
            
            operationA.complete(result: DataRequestResult.failure)
        }
        
        
        var callBackOnThreadB: OperationQueue!
        let expectationB = expectation(description: "Closure called")
        
        let operationB = CoalescibleOperation<Any>(identifier: "test")
        operationB.completion = {(successful) in
            callBackOnThreadB = OperationQueue.current!
            expectationB.fulfill()
        }
        
        operationB.complete(result: DataRequestResult.failure)
        
        waitForExpectations(timeout: 2) { (error) in
            XCTAssertEqual(callBackOnThreadA, queue)
            XCTAssertNotEqual(callBackOnThreadA, OperationQueue.main)
            
            XCTAssertEqual(callBackOnThreadB, OperationQueue.main)
        }
    }
    
    func test_didComplete_completedOperationLeavesQueue() {
        let expectation = self.expectation(description: "Operation removed from queue on completion")
        let operation = TestCoalescingOperation<Any>()
        operation.completion = {(successful) in
            expectation.fulfill()
        }
        
        let queue = OperationQueue()
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 2) { (error) in
            XCTAssertEqual(0, queue.operations.count)
        }
    }
    
    // MARK: Coalesce
    
    func test_coalesce_mutlipleClosuresCalled() {
        var operationACalledBack = false
        let expectationA = expectation(description: "First callback called")
        let operationA = CoalescibleOperation<Any>(identifier: "test")
        operationA.completion = {(successful) in
            operationACalledBack = true
            expectationA.fulfill()
        }
        
        var operationBCalledBack = false
        let expectationB = expectation(description: "Second callback called")
        let operationB = CoalescibleOperation<Any>(identifier: "test")
        operationB.completion = {(successful) in
            operationBCalledBack = true
            expectationB.fulfill()
        }
        
        operationA.coalesce(operationB)
        operationA.complete(result: DataRequestResult.failure)
        
        waitForExpectations(timeout: 2) { (error) in
            XCTAssertTrue(operationACalledBack)
            XCTAssertTrue(operationBCalledBack)
        }
    }
    
    func test_coalesce_secondClosuresCalledWhenFirstIsNotSet() {
        let operationA = CoalescibleOperation<Any>(identifier: "test")
        
        var operationBCalledBack = false
        let expectationB = expectation(description: "Second callback called")
        let operationB = CoalescibleOperation<Any>(identifier: "test")
        operationB.completion = {(successful) in
            operationBCalledBack = true
            expectationB.fulfill()
        }
        
        operationA.coalesce(operationB)
        operationA.complete(result: DataRequestResult.failure)
        
        waitForExpectations(timeout: 2) { (error) in
            XCTAssertTrue(operationBCalledBack)
        }
    }
    
    func test_coalesce_firstClosuresCalledWhenSecondIsNotSet() {
        var operationACalledBack = false
        let expectationA = expectation(description: "First callback called")
        let operationA = CoalescibleOperation<Any>(identifier: "test")
        operationA.completion = {(successful) in
            operationACalledBack = true
            expectationA.fulfill()
        }
        
        let operationB = CoalescibleOperation<Any>(identifier: "test")
        
        operationA.coalesce(operationB)
        operationA.complete(result: DataRequestResult.failure)
        
        waitForExpectations(timeout: 2) { (error) in
            XCTAssertTrue(operationACalledBack)
        }
    }
}

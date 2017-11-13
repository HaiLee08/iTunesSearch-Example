//
//  QueueManagerTests.swift
//  iTunesSearch-Example
//
//  Created by William Boles on 12/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import XCTest

@testable import iTunesSearch_Example

class QueueManagerTests: XCTestCase {
    
    class CoalescibleOperationSpy<T>: CoalescibleOperation<T> {
        
        // MARK: Properties
        
        var coalesceAttempted = false
        var coalesceAttemptedOnOperation: CoalescibleOperation<T>!
        
        // MARK: Init
        
        override init(identifier: String = "coalescibleOperationSpy") {
            super.init(identifier: identifier)
        }
        
        // MARK: Coalesce
        
        override func coalesce(_ operation: CoalescibleOperation<T>) {
            coalesceAttempted = true
            coalesceAttemptedOnOperation = operation
        }
    }
    
    // MARK: - Accessors
    
    var queueManager: QueueManager!
    
    // MARK: Lifecycle
    
    override func setUp() {
        super.setUp()
        
        queueManager = QueueManager()
        queueManager.queue.isSuspended = true
    }
    
    // MARK: - Tests
    
    // MARK: Enqueue
    
    func test_enqueue_count() {
        let operationA = Operation()
        
        queueManager.enqueue(operationA)
        
        XCTAssertEqual(queueManager.queue.operationCount, 1)
    }
    
    func test_enqueue_nonCoalescibleOperations() {
        let operationA = Operation()
        let operationB = Operation()
        
        queueManager.enqueue(operationA)
        queueManager.enqueue(operationB)
        
        XCTAssertEqual(queueManager.queue.operationCount, 2)
    }
    
    func test_enqueue_coalescibleOperations() {
        let operationA = CoalescibleOperationSpy<Any>()
        let operationB = CoalescibleOperationSpy<Any>()
        
        queueManager.enqueue(operationA)
        queueManager.enqueue(operationB)
        
        XCTAssertEqual(queueManager.queue.operationCount, 1)
    }
    
    func test_enqueue_coalesceOfOperationsAttempted() {
        let operationA = CoalescibleOperationSpy<Any>()
        let operationB = CoalescibleOperationSpy<Any>()
        
        queueManager.enqueue(operationA)
        queueManager.enqueue(operationB)
        
        XCTAssertTrue(operationA.coalesceAttempted)
    }
    
    func test_enqueue_coalesceOfOperationsAttemptedInOrder() {
        let operationA = CoalescibleOperationSpy<Any>()
        let operationB = CoalescibleOperationSpy<Any>()
        
        queueManager.enqueue(operationA)
        queueManager.enqueue(operationB)
        
        XCTAssertEqual(operationB, operationA.coalesceAttemptedOnOperation)
    }
    
    func test_enqueue_CoalescibleAndNonCoalescibleOperations() {
        let operationA = CoalescibleOperationSpy<Any>()
        let operationB = Operation()
        
        queueManager.enqueue(operationA)
        queueManager.enqueue(operationB)
        
        XCTAssertEqual(queueManager.queue.operationCount, 2)
    }
    
    // MARK: Existing
    
    func test_existingCoalescibleOperationOnQueue_noMatch() {
        let operation = CoalescibleOperationSpy<Any>()
        
        queueManager.enqueue(operation)
        
        XCTAssertNil(queueManager.existingCoalescibleOperationOnQueue("nonMatchIdentifier"))
    }
    
    func test_existingCoalescibleOperationOnQueue_match() {
        let operation = CoalescibleOperationSpy<Any>()
        
        queueManager.enqueue(operation)
        
        XCTAssertNotNil(queueManager.existingCoalescibleOperationOnQueue(operation.identifier))
    }
    
    func test_existingCoalescibleOperationOnQueue_matchWithCombinationOfCoalescibleAndNonCoalescibleOperations() {
        let operationA = Operation()
        let operationB = CoalescibleOperationSpy<Any>()
        
        queueManager.enqueue(operationA)
        queueManager.enqueue(operationB)
        
        XCTAssertNotNil(queueManager.existingCoalescibleOperationOnQueue(operationB.identifier))
    }
    
    func test_existingCoalescibleOperationOnQueue_noMatchWithCombinationOfCoalescibleAndNonCoalescibleOperations() {
        let operationA = Operation()
        let operationB = CoalescibleOperationSpy<Any>()
        
        queueManager.enqueue(operationA)
        queueManager.enqueue(operationB)
        
        XCTAssertNil(queueManager.existingCoalescibleOperationOnQueue("nonMatchIdentifier"))
    }
}

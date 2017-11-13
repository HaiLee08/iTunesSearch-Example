//
//  QueueManager.swift
//  iTunesSearch-Example
//
//  Created by William Boles on 13/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import Foundation

class QueueManager {
    
    lazy var queue: OperationQueue = {
        let queue = OperationQueue()
        
        return queue;
    }()

    // MARK: - Singleton
    
    static let shared = QueueManager()
    
    // MARK: - Addition
    
    func enqueue(_ operation: Operation) {
        if operation is CoalescibleOperation<Any> {
            let coalescibleOperation = operation as! CoalescibleOperation<Any>
            
            if let existingCoalescibleOperation = existingCoalescibleOperationOnQueue(coalescibleOperation.identifier){
                existingCoalescibleOperation.coalesce(coalescibleOperation)
            } else {
                queue.addOperation(coalescibleOperation)
            }
            
        } else {
            queue.addOperation(operation)
        }
    }
    
    // MARK: - Existing
    
    func existingCoalescibleOperationOnQueue(_ identifier: String) -> CoalescibleOperation<Any>? {
        let operations = self.queue.operations
        let matchingOperations = (operations).filter({(operation) -> Bool in
            if operation is CoalescibleOperation<Any> {
                let coalescibleOperation = operation as! CoalescibleOperation<Any>
                return identifier == coalescibleOperation.identifier
            }
            
            return false
        })
        
        return matchingOperations.first as? CoalescibleOperation
    }

}

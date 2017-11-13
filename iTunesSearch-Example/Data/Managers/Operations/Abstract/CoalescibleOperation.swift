//
//  CoalescibleOperation.swift
//  iTunesSearch-Example
//
//  Created by William Boles on 12/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import Foundation

class CoalescibleOperation<T>: ConcurrentOperation<T> {
    
    let identifier: String
    
    // MARK: - Init
    
    init(identifier: String) {
        self.identifier = identifier
        super.init()
    }
    
    // MARK: - Coalesce
    
    func coalesce(_ operation: CoalescibleOperation) {
        // Completion coalescing
        let initalCompletionClosure = self.completion
        let additionalCompletionClosure = operation.completion
        
        self.completion = {(successful) in
            if let initalCompletionClosure = initalCompletionClosure {
                initalCompletionClosure(successful)
            }
            
            if let additionalCompletionClosure = additionalCompletionClosure {
                additionalCompletionClosure(successful)
            }
        }
    }
}

//
//  ConcurrentOperation.swift
//  iTunesSearch-Example
//
//  Created by William Boles on 12/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import Foundation
import UIKit

class ConcurrentOperation<T>: Operation {
    
    typealias CompletionClosure = (_ result: DataRequestResult<T>) -> Void
    
    var completion: (CompletionClosure)?
    
    let callBackQueue = OperationQueue.current!
    
    // MARK: - Types
    
    enum State {
        case ready, executing, finished
        var keyPath: String {
            switch self {
            case .ready:
                return "isReady"
            case .executing:
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                }
                return "isExecuting"
            case .finished:
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                return "isFinished"
            }
        }
    }
    
    // MARK: - Properties
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    // MARK: - Operation
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    // MARK: - Control
    
    override func start() {
        super.start()
        
        if !isExecuting {
            state = .executing
        }
    }
    
    func finish() {
        if isExecuting {
            state = .finished
        }
    }
    
    func complete(result: DataRequestResult<T>) {
        finish()
        
        callBackQueue.addOperation {
            self.completion?(result)
        }
    }
    
    override func cancel() {
        super.cancel()
        
        finish()
    }
}

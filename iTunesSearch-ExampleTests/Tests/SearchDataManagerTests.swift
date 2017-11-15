//
//  SearchDataManagerTests.swift
//  iTunesSearch-ExampleTests
//
//  Created by William Boles on 13/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import XCTest

@testable import iTunesSearch_Example

class SearchDataManagerTests: XCTestCase {
    
    class QueueManagerSpy: QueueManager {
        
        var operationEnqueued: Operation?
        
        override func enqueue(_ operation: Operation) {
            operationEnqueued = operation
        }
    }
    
    var queueManagerSpy: QueueManagerSpy!
    var searchDataManager: SearchDataManager!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        queueManagerSpy = QueueManagerSpy()
        searchDataManager = SearchDataManager(queueManager: queueManagerSpy)
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_operationEnqueued() {
        let searchTerms = "swift"
        searchDataManager.retrieveMusicSearchResults(for: searchTerms) { (_, _) in }
        
        XCTAssertTrue(queueManagerSpy.operationEnqueued is MusicSearchRetrievalOperation)
        XCTAssertEqual((queueManagerSpy.operationEnqueued as! MusicSearchRetrievalOperation).searchTerms, searchTerms)
    }
}

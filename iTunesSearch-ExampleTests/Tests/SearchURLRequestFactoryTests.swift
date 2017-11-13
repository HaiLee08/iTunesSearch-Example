//
//  SearchURLRequestFactoryTests.swift
//  iTunesSearch-ExampleTests
//
//  Created by William Boles on 13/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import XCTest

@testable import iTunesSearch_Example

class SearchURLRequestFactoryTests: XCTestCase {
    
    class RequestFactoryMock: RequestFactory {
        let urlToBeReturned = URLRequest(url: URL(string: "http://www.test.com")!)
        var endPointPassedIn: String?
        
        override func request(endPoint: String, config: RequestConfig = RequestConfig()) -> URLRequest {
            endPointPassedIn = endPoint
            
            return urlToBeReturned
        }
    }
    
    var searchURLRequestFactory: SearchURLRequestFactory!
    var requestFactoryMock: RequestFactoryMock!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        requestFactoryMock = RequestFactoryMock()
        searchURLRequestFactory = SearchURLRequestFactory(factory: requestFactoryMock)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_retrieveMusicSearchRequest() {
        let searchTerm = "taylor"
        let request = searchURLRequestFactory.retrieveMusicSearchRequest(searchTerm)
        
        XCTAssertEqual(request.httpMethod, HTTPRequestMethod.get.rawValue)
        XCTAssertEqual(request.url, requestFactoryMock.urlToBeReturned.url)
        XCTAssertEqual("search?media=music&term=\(searchTerm)", requestFactoryMock.endPointPassedIn)
    }

}

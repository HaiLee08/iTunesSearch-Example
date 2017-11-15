//
//  SearchListViewModelTests.swift
//  iTunesSearch-ExampleTests
//
//  Created by William Boles on 14/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import XCTest

@testable import iTunesSearch_Example

class SearchListViewModelTests: XCTestCase {
    
    class SearchListViewModelDataSpy: SearchListViewModelData {
        
        var searchExpectation: XCTestExpectation?
        
        var retrieveMusicSearchResultsWasCalled = false
        var searchTermsPassedIn: String?
        
        var resultsToBeReturned: DataRequestResult<[SearchResult]> = DataRequestResult.failure
        
        func retrieveMusicSearchResults(for searchTerms: String, completion: @escaping ((_ searchTerms: String, _ result: DataRequestResult<[SearchResult]>) -> ())) {
            retrieveMusicSearchResultsWasCalled = true
            searchTermsPassedIn = searchTerms
            
            completion(searchTerms, resultsToBeReturned)
            
            searchExpectation?.fulfill()
        }
    }
    
    class TimerSpy: Timer {
        
        var invalidateWasCalled = false
        var scheduledTimerWasCalled = false
        var intervalPassedIn: TimeInterval?
        
        static var originalSelector = #selector(Timer.scheduledTimer(withTimeInterval:repeats:block:))
        static var swizzledSelector = #selector(TimerSpy.its_scheduledTimer(withTimeInterval:repeats:block:))
        
        @objc class func its_scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Swift.Void) -> Timer {
            
            let timerSpy = TimerSpy()
            timerSpy.intervalPassedIn = interval
            timerSpy.scheduledTimerWasCalled = true
            
            return timerSpy
        }
        
        override func invalidate() {
            invalidateWasCalled = true
        }
        
        class func swizzle() {
            NSObject.swizzleClassMethodSelector(originalSelector, ofClass: Timer.self, withSelector: swizzledSelector, withClass: TimerSpy.self)
        }
        
        class func unswizzle() {
            NSObject.swizzleClassMethodSelector(swizzledSelector, ofClass: TimerSpy.self, withSelector: originalSelector, withClass: Timer.self)
        }
    }
    
    var searchListViewModel: SearchListViewModel!
    var searchDataManagerSpy: SearchListViewModelDataSpy!
    
    let searchResult = SearchResult(artistName: "bob dylan", trackName: "bob's party anthem", artworkURL: URL(string: "http://test.com/artwork")!, price: 4.98, currency: "USD", trackDetailsURL: URL(string: "http://test.com/trackDetails")!)
    let viewModel = SearchResultViewModel(artistName: "bob dylan", trackName: "bob's party anthem", artworkURL: URL(string: "http://test.com/artwork")!, price: "$4.98")
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        searchDataManagerSpy = SearchListViewModelDataSpy()
        searchListViewModel = SearchListViewModel(searchDataManager: searchDataManagerSpy)
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    // MARK: Init
    
    func test_init_settingProperties() {
        XCTAssertTrue(searchDataManagerSpy === searchListViewModel.searchDataManager)
    }
    
    // MARK: Search
    
    func test_search_invalidatesExistingTimer() {
        let timerSpy = TimerSpy()
        searchListViewModel.timer = timerSpy
        
        searchListViewModel.search(for: "test terms")
        
        XCTAssertTrue(timerSpy.invalidateWasCalled)
    }
    
    func test_search_delayBeforeSearching() {
        TimerSpy.swizzle()
        
        searchListViewModel.search(for: "test terms")
        
        let timerSpy = searchListViewModel.timer as! TimerSpy
        
        XCTAssertEqual(timerSpy.intervalPassedIn, 0.8)
        
        TimerSpy.unswizzle()
    }
    
    func test_search_performSearch() {
        searchDataManagerSpy.searchExpectation = self.expectation(description: "search triggered")
        let searchTerms = "test search terms"
        searchListViewModel.search(for: searchTerms)
        
        waitForExpectations(timeout: 2) { (error) in
            XCTAssertTrue(self.searchDataManagerSpy.retrieveMusicSearchResultsWasCalled)
            XCTAssertEqual(self.searchDataManagerSpy.searchTermsPassedIn, searchTerms)
        }
    }
    
    func test_search_onlySearchWithValidTerms() {
        TimerSpy.swizzle()
        
        searchListViewModel.search(for: "")
        
        XCTAssertFalse(searchListViewModel.timer is TimerSpy)
        
        TimerSpy.unswizzle()
    }
    
    func test_search_resetOldSearchResults() {
        searchDataManagerSpy.searchExpectation = self.expectation(description: "search triggered")
        
        searchListViewModel.searchResults = [searchResult]
        searchListViewModel.viewModels = [viewModel]
        
        searchListViewModel.search(for: "test search terms")
        
        waitForExpectations(timeout: 2) { (error) in
            XCTAssertTrue(self.searchListViewModel.searchResults.isEmpty)
            XCTAssertTrue(self.searchListViewModel.viewModels.isEmpty)
        }
    }
    
    func test_search_setSearchResults() {
        searchDataManagerSpy.searchExpectation = self.expectation(description: "search triggered")
        searchDataManagerSpy.resultsToBeReturned = DataRequestResult.success([searchResult])
        
        searchListViewModel.search(for: "test search terms")
        
        waitForExpectations(timeout: 2) { (error) in
            XCTAssertEqual(self.searchListViewModel.searchResults.count, 1)
            XCTAssertEqual(self.searchListViewModel.searchResults[0], self.searchResult)
        }
    }
    
    func test_search_setViewModels() {
        searchDataManagerSpy.searchExpectation = self.expectation(description: "search triggered")
        searchDataManagerSpy.resultsToBeReturned = DataRequestResult.success([searchResult])
        
        searchListViewModel.search(for: "test search terms")
        
        waitForExpectations(timeout: 2) { (error) in
            XCTAssertEqual(self.searchListViewModel.viewModels.count, 1)
            XCTAssertEqual(self.searchListViewModel.viewModels[0], self.viewModel)
        }
    }
}

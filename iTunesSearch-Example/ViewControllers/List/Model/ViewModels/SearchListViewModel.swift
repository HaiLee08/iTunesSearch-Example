//
//  SearchListViewModel.swift
//  iTunesSearch-Example
//
//  Created by William Boles on 14/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import Foundation

class SearchListViewModel {
    
    var searchTerms: String? {
        didSet {
            viewModels = [SearchResultViewModel]()
            searchResults = [SearchResult]()
            scheduleTimerForTriggeringNextSearch()
        }
    }
    
    private var timer: Timer?
    
    private var viewModels = [SearchResultViewModel]() {
        didSet {
            self.reloadTableView?()
        }
    }
    
    let searchDataManager: SearchDataManager
    
    var updateLoadingStatus: (() -> ())?
    var reloadTableView: (() -> ())?
    
    private var searchResults = [SearchResult]()
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    // MARK: - Init
    
    init(searchDataManager: SearchDataManager = SearchDataManager()) {
        self.searchDataManager = searchDataManager
    }
    
    // MARK: - Timer
    
    func scheduleTimerForTriggeringNextSearch() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { timer in
            if !(self.searchTerms?.isEmpty ?? true) {
                self.retrieveResultsFor(searchTerms: self.searchTerms!)
            }
        })
    }
    
    // MARK: - Retrieval
    
    func retrieveResultsFor(searchTerms: String) {
        isLoading = true
        searchDataManager.retrieveMusicSearchResults(for: searchTerms) { (searchTerms, result) in
            guard searchTerms == self.searchTerms else {
                return
            }
            
            self.isLoading = false
            switch result {
            case .success(let searchResults):
                self.searchResults = searchResults
                self.viewModels = self.searchResultViewModels(searchResults: searchResults)
            case .failure:
                print("failed to retrieve search results")
            }
        }
    }
    
    func searchResultViewModels(searchResults: [SearchResult]) -> [SearchResultViewModel] {
        
        var viewModels = [SearchResultViewModel]()
        
        for searchResult in searchResults {
            let priceFormatter = NumberFormatter()
            priceFormatter.numberStyle = .currency
            priceFormatter.currencyCode = searchResult.currency
            
            if let price = priceFormatter.string(from: NSNumber(value: searchResult.price)) {
                let viewModel = SearchResultViewModel(artistName: searchResult.artistName, trackName: searchResult.trackName, artworkURL: searchResult.artworkURL, price: price)
                viewModels.append(viewModel)
            }
        }
        
        return viewModels
    }
    
    // MARK: - Data
    
    func numberOfCells() -> Int {
        return viewModels.count
    }
    
    func viewModel(at index: Int) -> SearchResultViewModel {
        return viewModels[index]
    }
    
    func searchResult(at index: Int) -> SearchResult {
        return searchResults[index]
    }
    
    // MARK: - Detail
    
    func detailViewModel(searchResult: SearchResult) -> DetailViewModel {
        return DetailViewModel(searchResult: searchResult)
    }
}

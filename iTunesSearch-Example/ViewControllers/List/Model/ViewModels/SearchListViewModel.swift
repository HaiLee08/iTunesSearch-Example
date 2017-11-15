//
//  SearchListViewModel.swift
//  iTunesSearch-Example
//
//  Created by William Boles on 14/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import Foundation

protocol SearchListViewModelDelegate {
    func didStartSearching()
    func didStopSearching(viewModels: [SearchResultViewModel])
}

protocol SearchListViewModelData: class {
    func retrieveMusicSearchResults(for searchTerms: String, completion: @escaping ((_ searchTerms: String, _ result: DataRequestResult<[SearchResult]>) -> ()))
}

extension SearchDataManager: SearchListViewModelData { }

class SearchListViewModel {
    var currentSearchTerms: String?
    var timer: Timer?

    let searchDataManager: SearchListViewModelData
    
    var delegate: SearchListViewModelDelegate?
    
    var searchResults = [SearchResult]()
    var viewModels = [SearchResultViewModel]()
    
    // MARK: - Init
    
    init(searchDataManager: SearchListViewModelData = SearchDataManager()) {
        self.searchDataManager = searchDataManager
    }
    
    // MARK: - Search
    
    func search(for searchTerms: String) {
        resetCurrentSearch()
        currentSearchTerms = searchTerms
        delegate?.didStartSearching()
        timer?.invalidate()
        if !searchTerms.isEmpty {
            timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { timer in
                self.retrieveResults(for: searchTerms)
            })
        } else {
            delegate?.didStopSearching(viewModels: viewModels)
        }
    }
    
    // MARK: - Retrieval
    
    func resetCurrentSearch() {
        currentSearchTerms = nil
        searchResults.removeAll()
        viewModels.removeAll()
    }
    
    private func retrieveResults(for searchTerms: String) {
        searchDataManager.retrieveMusicSearchResults(for: searchTerms) { (searchTerms, result) in
            guard searchTerms == self.currentSearchTerms else {
                return
            }
            
            switch result {
            case .success(let searchResults):
                self.searchResults = searchResults
                self.viewModels = self.buildSearchResultViewModels(searchResults: searchResults)
                self.delegate?.didStopSearching(viewModels: self.viewModels)
            case .failure:
                //handle error state
                break
            }
        }
    }
    
    private func buildSearchResultViewModels(searchResults: [SearchResult]) -> [SearchResultViewModel] {
        
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
}

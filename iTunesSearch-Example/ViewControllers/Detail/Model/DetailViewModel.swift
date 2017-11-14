//
//  DetailViewModel.swift
//  iTunesSearch-Example
//
//  Created by William Boles on 14/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import Foundation

struct DetailViewModel {
    
    let trackDetailsURLRequest: URLRequest
    
    // MARK: - Init
    
    init(searchResult: SearchResult) {
        self.trackDetailsURLRequest = URLRequest(url: searchResult.trackDetailsURL)
    }
}

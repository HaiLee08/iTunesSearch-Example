//
//  SearchResult.swift
//  iTunesSearch-Example
//
//  Created by William Boles on 12/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import Foundation

struct SearchResult {
    
    let artistName: String
    let trackName: String
    let artworkURL: URL
    let genre: String
    let price: Double
    let currency: String
}

extension SearchResult: Equatable { }

func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
    return lhs.artistName == rhs.artistName
        && lhs.trackName == rhs.trackName
        && lhs.artworkURL == rhs.artworkURL
        && lhs.genre == rhs.genre
        && lhs.price == rhs.price
        && lhs.currency == rhs.currency
}

//
//  SearchResultViewModel.swift
//  iTunesSearch-Example
//
//  Created by William Boles on 14/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import Foundation

struct SearchResultViewModel {
    
    let artistName: String
    let trackName: String
    let artworkURL: URL
    let price: String
}

extension SearchResultViewModel: Equatable { }

func == (lhs: SearchResultViewModel, rhs: SearchResultViewModel) -> Bool {
    return lhs.artistName == rhs.artistName
        && lhs.trackName == rhs.trackName
        && lhs.artworkURL == rhs.artworkURL
        && lhs.price == rhs.price
}

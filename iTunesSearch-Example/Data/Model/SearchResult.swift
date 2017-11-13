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
    let previewArtworkURL: URL
    let detailArtworkURL: URL
    let genre: String
}

extension SearchResult: Equatable { }

func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
    return lhs.artistName == rhs.artistName
        && lhs.trackName == rhs.trackName
        && lhs.previewArtworkURL == rhs.detailArtworkURL
        && lhs.genre == rhs.genre
}

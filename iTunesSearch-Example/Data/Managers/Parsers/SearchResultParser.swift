//
//  SearchResultParser.swift
//  iTunesSearch-Example
//
//  Created by William Boles on 12/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import Foundation

class SearchResultParser: Parser<[SearchResult]> {
    
    // MARK: - Parse
    
    override func parseResponse(_ response: [String: Any]) -> [SearchResult] {
        var searchResults = [SearchResult]()
        
        guard let searchResultsResponse = response["results"] as? [[String: Any]] else {
            return searchResults
        }
        
        for searchResultResponse in searchResultsResponse {
            if let searchResult = parseSearchResult(searchResultResponse) {
                searchResults.append(searchResult)
            }
        }

        return searchResults
    }
    
    private func parseSearchResult(_ searchResultResponse: [String: Any]) -> SearchResult? {
        guard let artistName = searchResultResponse["artistName"] as? String,
            let trackName = searchResultResponse["trackName"] as? String,
            let artworkString = searchResultResponse["artworkUrl100"] as? String,
            let artworkURL = URL(string: artworkString),
            let genre = searchResultResponse["primaryGenreName"] as? String,
            let price = searchResultResponse["trackPrice"] as? Double,
            let currency = searchResultResponse["currency"] as? String else {
            return nil
        }
        
        return SearchResult(artistName: artistName, trackName: trackName, artworkURL: artworkURL, genre: genre, price: price, currency: currency)
    }
}

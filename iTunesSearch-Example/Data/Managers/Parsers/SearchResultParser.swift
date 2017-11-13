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
            let previewArtworkString = searchResultResponse["artworkUrl30"] as? String,
            let previewArtworkURL = URL(string: previewArtworkString),
            let detailArtworkString = searchResultResponse["artworkUrl100"] as? String,
            let detailArtworkURL = URL(string: detailArtworkString),
            let genre = searchResultResponse["primaryGenreName"] as? String else {
            return nil
        }
        
        return SearchResult(artistName: artistName, trackName: trackName, previewArtworkURL: previewArtworkURL, detailArtworkURL: detailArtworkURL, genre: genre)
    }
}

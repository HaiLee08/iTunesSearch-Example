//
//  MusicSearchRetrievalOperation.swift
//  iTunesSearch-Example
//
//  Created by William Boles on 12/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import Foundation

class MusicSearchRetrievalOperation: CoalescibleOperation<[SearchResult]>{
    
    let urlRequestFactory: SearchURLRequestFactory
    let session: URLSession
    let searchTerms: String
    
    // MARK: - Init
    
    init(searchTerms: String, session: URLSession = URLSession.shared, urlRequestFactory: SearchURLRequestFactory = SearchURLRequestFactory()) {
        self.session = session
        self.urlRequestFactory = urlRequestFactory
        self.searchTerms = searchTerms
        super.init(identifier: searchTerms)
    }
    
    // MARK: - Start
    
    override func start() {
        super.start()
        
        let request = urlRequestFactory.retrieveMusicSearchRequest(searchTerms)
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil || data == nil {
                self.complete(result: DataRequestResult.failure)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                print(json)
                
                let parser = SearchResultParser()
                let searchResults = parser.parseResponse(json)
                
                self.complete(result: DataRequestResult.success(searchResults))
            } catch {
                self.complete(result: DataRequestResult.failure)
            }
        }
        
        task.resume()
    }
}

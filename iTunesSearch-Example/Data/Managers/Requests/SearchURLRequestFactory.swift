//
//  DockingStationURLRequestFactory.swift
//  iTunesSearch-Example
//
//  Created by William Boles on 13/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import Foundation

class SearchURLRequestFactory {
    
    let factory: RequestFactory
    
    // MARK: - Init
    
    init(factory: RequestFactory = RequestFactory()) {
        self.factory = factory
    }
    
    // MARK: - Retrieval
    
    func retrieveMusicSearchRequest(_ searchTerm: String) -> URLRequest {
        var request = factory.request(endPoint: "search?media=music&term=\(searchTerm)")
        request.httpMethod = HTTPRequestMethod.get.rawValue
        
        return request
    }
}

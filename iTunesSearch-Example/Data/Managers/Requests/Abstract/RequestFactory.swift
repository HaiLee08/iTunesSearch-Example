//
//  RequestFactory.swift
//  iTunesSearch-Example
//
//  Created by William Boles on 12/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import Foundation

class RequestFactory {
    
    // MARK: - Factory
    
    func request(endPoint: String, config: RequestConfig = RequestConfig()) -> URLRequest {
        let stringURL = "\(config.APIHost)/\(endPoint)"
        let encodedStringURL = stringURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: encodedStringURL!)!
    
        return URLRequest(url: url)
    }
}

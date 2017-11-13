//
//  RequestConfig.swift
//  iTunesSearch-Example
//
//  Created by William Boles on 12/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import Foundation

enum HTTPRequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class RequestConfig {
    
    // MARK: Networking
    
    lazy var APIHost: String = {
        return "https://itunes.apple.com"
    }()
    
    lazy var timeInterval: TimeInterval = {
        return 45
    }()
    
    lazy var cachePolicy: NSURLRequest.CachePolicy = {
        return .useProtocolCachePolicy
    }()
}

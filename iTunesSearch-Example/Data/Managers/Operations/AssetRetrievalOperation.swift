//
//  AssetRetrievalOperation.swift
//  iTunesSearch-Example
//
//  Created by William Boles on 14/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import UIKit

class AssetRetrievalOperation: CoalescibleOperation<Data>{
    
    let session: URLSession
    let url: URL
    
    // MARK: - Init
    
    init(url: URL, session: URLSession = URLSession.shared) {
        self.session = session
        self.url = url
        super.init(identifier: url.absoluteString)
    }
    
    // MARK: - Start
    
    override func start() {
        super.start()
        
        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil || data == nil {
                self.complete(result: DataRequestResult.failure)
                return
            }
            
            self.complete(result: DataRequestResult.success(data!))
        }
        
        task.resume()
    }
}

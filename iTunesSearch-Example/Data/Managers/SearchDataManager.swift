//
//  SearchDataManager.swift
//  iTunesSearch-Example
//
//  Created by William Boles on 12/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import Foundation

enum DataRequestResult<T> {
    case success(T)
    case failure
}

class SearchDataManager {
    
    let queueManager: QueueManager
    
    // MARK: - Init
    
    init(queueManager: QueueManager = QueueManager.shared) {
        self.queueManager = queueManager
    }
    
    // MARK: - Music
    
    func retrieveMusicSearchResults(for searchTerms: String, completion: @escaping ((_ result: DataRequestResult<[SearchResult]>) -> ())) {
        let operation = MusicSearchRetrievalOperation(searchTerms: searchTerms)
        operation.completion = { (result: DataRequestResult) in
            completion(result)
        }
        
        queueManager.enqueue(operation)
    }
}

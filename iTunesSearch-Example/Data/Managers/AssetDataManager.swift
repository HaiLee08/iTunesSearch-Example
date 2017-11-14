//
//  AssetDataManager.swift
//  iTunesSearch-Example
//
//  Created by William Boles on 14/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import UIKit

class AssetDataManager {
    
    let queueManager: QueueManager
    
    // MARK: - Init
    
    init(queueManager: QueueManager = QueueManager.shared) {
        self.queueManager = queueManager
    }
    
    // MARK: - Image
    
    func retrieveImageAsset(for url: URL, completion: @escaping ((_ result: DataRequestResult<UIImage>) -> ())) {
        let operation = AssetRetrievalOperation(url: url)
        operation.completion = { (result: DataRequestResult) in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completion(DataRequestResult.failure)
                    return
                }
                completion(DataRequestResult.success(image))
            case .failure:
                completion(DataRequestResult.failure)
            }
        }
        
        queueManager.enqueue(operation)
    }
}

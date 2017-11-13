//
//  SearchListViewController.swift
//  iTunesSearch-Example
//
//  Created by William Boles on 12/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import UIKit

class SearchListViewController: UIViewController {

    // MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchDataManager = SearchDataManager()
        searchDataManager.retrieveMusicSearchResults(for: "swift") { (result) in
            print(result)
        }
    }
}


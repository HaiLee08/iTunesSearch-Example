//
//  SearchListViewController.swift
//  iTunesSearch-Example
//
//  Created by William Boles on 12/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import UIKit

class SearchListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!

    lazy var searchListViewModel: SearchListViewModel = {
       let searchListViewModel = SearchListViewModel()
        searchListViewModel.updateLoadingStatus = {
            let isLoading = searchListViewModel.isLoading
            if isLoading {
                self.loadingActivityIndicator.startAnimating()
                self.tableView.alpha = 0.0
            }else {
                self.loadingActivityIndicator.stopAnimating()
                self.tableView.alpha = 1.0
            }
        }
        
        searchListViewModel.reloadTableView = {
            self.tableView.reloadData()
        }
        
        return searchListViewModel
    }()
    
    // MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Search", comment: "")
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchResultSegue" {
            if let detailViewController = segue.destination as? DetailViewController,
                let cell = sender as? SearchResultTableViewCell,
                let indexPath = tableView.indexPath(for: cell) {
                let searchResult = searchListViewModel.searchResult(at: indexPath.row)
                detailViewController.viewModel = searchListViewModel.detailViewModel(searchResult: searchResult)
            }
        }
    }
}

extension SearchListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchListViewModel.searchTerms = searchBar.text
    }
}

extension SearchListViewController: UITableViewDelegate { }

extension SearchListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchListViewModel.numberOfCells()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.className, for: indexPath) as? SearchResultTableViewCell else {
            fatalError() // fail fast
        }
        let viewModel = searchListViewModel.viewModel(at: indexPath.row)
    
        cell.viewModel = viewModel
        
        return cell
    }
}


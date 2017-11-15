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
       searchListViewModel.delegate = self
        
        return searchListViewModel
    }()
    
    // MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Search", comment: "")
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardChange(_:)), name: .UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardChange(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchResultSegue" {
            if let detailViewController = segue.destination as? DetailViewController,
                let cell = sender as? SearchResultTableViewCell,
                let indexPath = tableView.indexPath(for: cell) {
                let searchResult = searchListViewModel.searchResults[indexPath.row]
                detailViewController.viewModel = DetailViewModel(searchResult: searchResult)
            }
        }
    }
    
    // MARK: - Keyboard
    
    @objc func keyboardChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            tableView.contentInset = UIEdgeInsets.zero
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
    }
}

extension SearchListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchListViewModel.search(for: searchBar.text ?? "")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension SearchListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        view.endEditing(true)
    }
}

extension SearchListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchListViewModel.viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.className, for: indexPath) as? SearchResultTableViewCell else {
            fatalError("unknown cell type being used") // fail fast
        }
        
        let viewModel = searchListViewModel.viewModels[indexPath.row]
        cell.viewModel = viewModel
        
        return cell
    }
}

extension SearchListViewController: SearchListViewModelDelegate {
    
    func didStartSearching() {
        self.tableView.reloadData()
        loadingActivityIndicator.startAnimating()
    }
    
    func didStopSearching(viewModels: [SearchResultViewModel]) {
        loadingActivityIndicator.stopAnimating()
        tableView.reloadData()
        
        //Handle no results
    }
}


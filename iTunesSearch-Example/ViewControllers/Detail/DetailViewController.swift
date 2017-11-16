//
//  DetailViewController.swift
//  iTunesSearch-Example
//
//  Created by William Boles on 13/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    var viewModel: DetailViewModel!
    
    // MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingActivityIndicator.startAnimating()
        webView.navigationDelegate = self
        webView.load(viewModel.trackDetailsURLRequest)
    }
}

extension DetailViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingActivityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        loadingActivityIndicator.stopAnimating()
        
        let alertController = UIAlertController(title: NSLocalizedString("Unable to open", comment: ""), message: NSLocalizedString("Sadly, an error occurred", comment: ""), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}

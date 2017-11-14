//
//  SearchResultTableViewCell.swift
//  iTunesSearch-Example
//
//  Created by William Boles on 13/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var previewImageView: UIImageView!
    
    var viewModel: SearchResultViewModel? {
        didSet {
            if let viewModel = viewModel {
                configure(viewModel)
            }
        }
    }
    
    let assetDataManger = AssetDataManager()
    
    // MARK: - ViewLifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        previewImageView.image = UIImage(named: "icon-artwork-placeholder")
    }
    
    // MARK: - Configure
    
    private func configure(_ viewModel: SearchResultViewModel) {
        artistLabel.text = viewModel.artistName
        trackLabel.text = viewModel.trackName
        priceLabel.text = viewModel.price
        
        imageFor(searchResultViewModel: viewModel) { (viewModel, image) in
            if viewModel == self.viewModel {
                if let image = image {
                    self.previewImageView.image = image
                }
            }
        }
    }
    
    private func imageFor(searchResultViewModel: SearchResultViewModel, completion: @escaping ((_ searchResultViewModel: SearchResultViewModel,  _ image: UIImage?) -> ())) {
        assetDataManger.retrieveImageAsset(for: searchResultViewModel.artworkURL) { (result) in
            switch result {
            case .success(let image):
                completion(searchResultViewModel, image)
            case .failure:
                completion(searchResultViewModel, nil)
            }
        }
    }
}

//
//  SearchViewController2.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/27/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    let searchCollection:SearchCollection = {
        let collection = SearchCollection()
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()

    var searchItems = [TVItem]()
    
    override func viewDidLoad() {
        createElementsAndConstraints()
    }
    
    func createElementsAndConstraints() {
        view.addSubview(searchCollection)
        searchCollectionConstraints()
    }
    
    func searchCollectionConstraints() {
        NSLayoutConstraint.activate([
            searchCollection.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            searchCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchCollection.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchCollection.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
}
